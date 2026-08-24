# frozen_string_literal: true

if Rails.application.credentials.dig(:stripe, :secret_key).present?
  Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
  Stripe.api_version = "2024-06-20"
end
