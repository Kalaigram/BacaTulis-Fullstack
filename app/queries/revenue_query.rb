class RevenueQuery
  def initialize(creator)
    @creator = creator
  end

  def dashboard_stats
    {
      mrr: mrr,
      subscriber_count: subscriber_count,
      new_subscribers_this_month: new_subscribers_this_month,
      churn_rate: churn_rate,
      revenue_by_month: revenue_by_month,
      top_paid_posts: top_paid_posts,
      subscription_tiers: subscription_tiers
    }
  end

  def mrr
    @creator.active_subscriptions_as_creator.sum { |s| s.monthly_amount }
  end

  def subscriber_count
    @creator.active_subscriber_count
  end

  def new_subscribers_this_month
    @creator.subscriptions_as_creator
            .where(status: :active)
            .where("created_at >= ?", 1.month.ago.beginning_of_month)
            .count
  end

  def churn_rate(months = 3)
    start_date = months.months.ago.beginning_of_month
    end_date = Time.current.end_of_month

    total_start = @creator.subscriptions_as_creator
                          .where("created_at < ?", start_date)
                          .where("canceled_at IS NULL OR canceled_at > ?", start_date)
                          .count

    churned = @creator.subscriptions_as_creator
                      .where(canceled_at: start_date..end_date)
                      .count

    return 0 if total_start.zero?

    (churned.to_f / total_start * 100).round(2)
  end

  def revenue_by_month(months = 12)
    subscriptions = @creator.subscriptions_as_creator
                           .where("created_at >= ?", months.months.ago.beginning_of_month)

    subscriptions.group_by { |s| s.created_at.beginning_of_month }
                 .transform_values { |subs| subs.sum(&:monthly_amount) }
                 .sort
                 .to_h
  end

  def top_paid_posts(limit = 10)
    @creator.posts.paid.published
            .left_joins(:post_views)
            .select("posts.*, COUNT(post_views.id) as views_count")
            .group("posts.id")
            .order("views_count DESC")
            .limit(limit)
  end

  def subscription_tiers
    @creator.active_subscriptions_as_creator
            .group(:stripe_price_id)
            .count
            .transform_keys { |price_id| StripeService.tier_name(price_id) }
  end
end
