module Creator
  class SubscriptionsController < BaseController
    def index
      @subscriptions = current_user.active_subscriptions_as_creator
                                   .includes(:subscriber)
                                   .recent
                                   .page(params[:page])
                                   .per(20)

      @total_subscribers = current_user.active_subscriber_count
      @mrr = current_user.monthly_recurring_revenue
    end

    def show
      @subscription = current_user.subscriptions_as_creator.find(params[:id])
      @subscriber = @subscription.subscriber
    end
  end
end
