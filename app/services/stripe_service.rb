class StripeService
  class Error < StandardError; end

  def self.configured?
    Rails.application.credentials.dig(:stripe, :secret_key).present?
  end

  def self.api_key
    Rails.application.credentials.dig(:stripe, :secret_key)
  end

  def self.publishable_key
    Rails.application.credentials.dig(:stripe, :publishable_key)
  end

  def self.webhook_secret
    Rails.application.credentials.dig(:stripe, :webhook_secret)
  end

  def self.basic_price_id
    Rails.application.credentials.dig(:stripe, :prices, :basic)
  end

  def self.premium_price_id
    Rails.application.credentials.dig(:stripe, :prices, :premium)
  end

  def self.create_customer(user)
    return user.stripe_customer_id if user.stripe_customer_id.present?

    customer = Stripe::Customer.create(
      email: user.email_address,
      metadata: { user_id: user.id }
    )
    user.update!(stripe_customer_id: customer.id)
    customer.id
  end

  def self.create_checkout_session(creator, price_id, subscriber, success_url, cancel_url)
    raise Error, "Stripe not configured" unless configured?

    customer_id = subscriber.create_stripe_customer!

    session = Stripe::Checkout::Session.create(
      customer: customer_id,
      payment_method_types: [ "card" ],
      line_items: [ {
        price: price_id,
        quantity: 1
      } ],
      mode: "subscription",
      success_url: success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: cancel_url,
      metadata: {
        creator_id: creator.id,
        subscriber_id: subscriber.id,
        price_id: price_id
      },
      subscription_data: {
        metadata: {
          creator_id: creator.id,
          subscriber_id: subscriber.id
        }
      }
    )
    session
  end

  def self.create_portal_session(customer_id, return_url)
    raise Error, "Stripe not configured" unless configured?

    session = Stripe::BillingPortal::Session.create(
      customer: customer_id,
      return_url: return_url
    )
    session
  end

  def self.create_connect_account(user)
    return user.stripe_account_id if user.stripe_account_id.present?

    account = Stripe::Account.create(
      type: "express",
      email: user.email_address,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true }
      },
      business_type: "individual",
      metadata: { user_id: user.id }
    )
    user.update!(stripe_account_id: account.id)
    account.id
  end

  def self.create_account_link(account_id, refresh_url, return_url)
    raise Error, "Stripe not configured" unless configured?

    link = Stripe::AccountLink.create(
      account: account_id,
      refresh_url: refresh_url,
      return_url: return_url,
      type: "account_onboarding"
    )
    link
  end

  def self.get_account(account_id)
    Stripe::Account.retrieve(account_id)
  end

  def self.construct_webhook_event(payload, sig_header)
    Stripe::Webhook.construct_event(payload, sig_header, webhook_secret)
  end

  def self.price_amount(price_id)
    case price_id
    when basic_price_id then 500
    when premium_price_id then 1500
    else 0
    end
  end

  def self.tier_name(price_id)
    case price_id
    when basic_price_id then "Basic"
    when premium_price_id then "Premium"
    else "Custom"
    end
  end
end
