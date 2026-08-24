class AnalyticsQuery
  def initialize(admin_user)
    @admin = admin_user
  end

  def dashboard_stats
    {
      total_posts: Post.count,
      published_posts: Post.published.count,
      total_views: PostView.count,
      total_users: User.count,
      popular_posts: top_posts,
      views_by_day: views_chart_data,
      engagement_rate: calculate_engagement
    }
  end

  def top_posts(limit = 10)
    Post.left_joins(:likes, :comments)
        .select("posts.*, COUNT(DISTINCT likes.id) as likes_count, COUNT(DISTINCT comments.id) as comments_count")
        .group("posts.id")
        .order(Arel.sql("likes_count + comments_count DESC"))
        .limit(limit)
  end

  def views_chart_data(days = 30)
    PostView.where(viewed_at: days.days.ago..)
            .group("DATE(viewed_at)")
            .count
  end

  private

  def calculate_engagement
    total_views = PostView.count
    return 0 if total_views.zero?

    (Like.count + Comment.count).to_f / total_views * 100
  end
end
