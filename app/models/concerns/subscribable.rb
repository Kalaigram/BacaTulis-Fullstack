module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions_as_creator, class_name: "Subscription", foreign_key: :creator_id, dependent: :destroy
    has_many :subscribers, through: :subscriptions_as_creator, source: :subscriber

    has_many :subscriptions_as_subscriber, class_name: "Subscription", foreign_key: :subscriber_id, dependent: :destroy
    has_many :creators_subscribed_to, through: :subscriptions_as_subscriber, source: :creator

    has_many :active_subscriptions_as_creator, -> { active }, class_name: "Subscription", foreign_key: :creator_id
    has_many :active_subscribers, through: :active_subscriptions_as_creator, source: :subscriber

    has_many :active_subscriptions_as_subscriber, -> { active }, class_name: "Subscription", foreign_key: :subscriber_id
    has_many :active_creators, through: :active_subscriptions_as_subscriber, source: :creator
  end

  def subscribed_to?(creator)
    active_subscriptions_as_subscriber.exists?(creator: creator)
  end

  def subscriber_of?(creator)
    subscriptions_as_subscriber.exists?(creator: creator)
  end

  def active_subscriber_count
    active_subscribers.count
  end

  def monthly_recurring_revenue
    active_subscriptions_as_creator.sum { |s| s.monthly_amount }
  end

  def stripe_customer
    return nil unless stripe_customer_id.present?
    Stripe::Customer.retrieve(stripe_customer_id)
  rescue Stripe::StripeError
    nil
  end

  def create_stripe_customer!
    return stripe_customer_id if stripe_customer_id.present?

    customer = Stripe::Customer.create(
      email: email_address,
      metadata: { user_id: id }
    )
    update!(stripe_customer_id: customer.id)
    customer.id
  end
end
