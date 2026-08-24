module Admin
  class AnalyticsController < BaseController
    def index
      @analytics = AnalyticsQuery.new(current_user).dashboard_stats
      @period = params[:period] || "week"
    end

    def post
      @post = Post.find(params[:id])
      @views = @post.post_views.order(viewed_at: :desc).limit(100)
      @daily_views = @post.post_views
                          .where(viewed_at: 30.days.ago..)
                          .group("DATE(viewed_at)")
                          .count
    end
  end
end
