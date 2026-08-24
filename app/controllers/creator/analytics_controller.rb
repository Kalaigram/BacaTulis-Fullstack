module Creator
  class AnalyticsController < BaseController
    def index
      @analytics = RevenueQuery.new(current_user).dashboard_stats
      @period = params[:period] || "month"
    end
  end
end
