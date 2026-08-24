class SubscriptionManager
  class Error < StandardError; end

  def self.subscribe(creator, subscriber, price_id)
    raise Error, "Cannot subscribe to yourself" if creator == subscriber

    existing = Subscription.find_by(creator: creator, subscriber: subscriber)
    if existing&.active?
      raise Error, "Already subscribed to this creator"
    end

    session = StripeService.create_checkout_session(
      creator,
      price_id,
      subscriber,
      Rails.application.routes.url_helpers.subscriptions_success_url,
      Rails.application.routes.url_helpers.subscriptions_new_url
    )

    { session_id: session.id, url: session.url }
  end

  def self.handle_checkout_completed(session)
    subscription_data = session.subscription
    return unless subscription_data

    metadata = subscription_data.metadata
    creator_id = metadata["creator_id"]
    subscriber_id = metadata["subscriber_id"]
    price_id = metadata["price_id"]

    creator = User.find_by(id: creator_id)
    subscriber = User.find_by(id: subscriber_id)

    return unless creator && subscriber

    subscription = Subscription.find_or_initialize_by(
      creator: creator,
      subscriber: subscriber
    )

    subscription.assign_attributes(
      status: :active,
      stripe_subscription_id: subscription_data.id,
      stripe_price_id: price_id,
      stripe_customer_id: subscription_data.customer,
      current_period_start: Time.at(subscription_data.current_period_start),
      current_period_end: Time.at(subscription_data.current_period_end)
    )

    subscription.save!

    Notification.create!(
      user: creator,
      actor: subscriber,
      action: "subscribed",
      notifiable: subscription
    )

    subscription
  end

  def self.handle_subscription_updated(subscription_data)
    subscription = Subscription.find_by(stripe_subscription_id: subscription_data.id)
    return unless subscription

    subscription.assign_attributes(
      status: map_stripe_status(subscription_data.status),
      current_period_start: Time.at(subscription_data.current_period_start),
      current_period_end: Time.at(subscription_data.current_period_end),
      canceled_at: subscription_data.canceled_at ? Time.at(subscription_data.canceled_at) : nil
    )

    subscription.save!
  end

  def self.handle_subscription_deleted(subscription_data)
    subscription = Subscription.find_by(stripe_subscription_id: subscription_data.id)
    return unless subscription

    subscription.update!(status: :canceled, canceled_at: Time.current)
  end

  def self.handle_invoice_payment_failed(invoice_data)
    subscription = Subscription.find_by(stripe_subscription_id: invoice_data.subscription)
    return unless subscription

    subscription.update!(status: :past_due)

    Notification.create!(
      user: subscription.subscriber,
      actor: subscription.creator,
      action: "payment_failed",
      notifiable: subscription
    )
  end

  def self.cancel_subscription(subscription)
    return false unless subscription.active?

    Stripe::Subscription.update(
      subscription.stripe_subscription_id,
      { cancel_at_period_end: true }
    )

    subscription.update!(canceled_at: Time.current)
    true
  rescue Stripe::StripeError => e
    Rails.logger.error "Failed to cancel subscription: #{e.message}"
    false
  end

  def self.reactivate_subscription(subscription)
    return false unless subscription.canceled?

    Stripe::Subscription.update(
      subscription.stripe_subscription_id,
      { cancel_at_period_end: false }
    )

    subscription.update!(canceled_at: nil, status: :active)
    true
  rescue Stripe::StripeError => e
    Rails.logger.error "Failed to reactivate subscription: #{e.message}"
    false
  end

  private

  def self.map_stripe_status(stripe_status)
    case stripe_status
    when "active" then :active
    when "canceled" then :canceled
    when "past_due" then :past_due
    when "trialing" then :trialing
    else :active
    end
  end
end
