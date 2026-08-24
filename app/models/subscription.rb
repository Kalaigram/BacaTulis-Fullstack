class Subscription < ApplicationRecord
  belongs_to :subscriber, class_name: "User"
  belongs_to :creator, class_name: "User"

  enum :status, { active: 0, canceled: 1, past_due: 2, trialing: 3 }

  scope :active_for_creator, ->(creator) { where(creator: creator, status: :active) }
  scope :active_for_subscriber, ->(subscriber) { where(subscriber: subscriber, status: :active) }
  scope :recent, -> { order(created_at: :desc) }

  validates :subscriber_id, uniqueness: { scope: :creator_id }
  validates :stripe_subscription_id, uniqueness: true, allow_nil: true

  def active?
    status == "active" || status == "trialing"
  end

  def tier_name
    case stripe_price_id
    when Rails.application.credentials.dig(:stripe, :prices, :basic)
      "Basic"
    when Rails.application.credentials.dig(:stripe, :prices, :premium)
      "Premium"
    else
      "Custom"
    end
  end

  def monthly_amount
    case stripe_price_id
    when Rails.application.credentials.dig(:stripe, :prices, :basic)
      500
    when Rails.application.credentials.dig(:stripe, :prices, :premium)
      1500
    else
      0
    end
  end
end
