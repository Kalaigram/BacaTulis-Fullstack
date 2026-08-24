class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :require_authentication

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

    begin
      event = StripeService.construct_webhook_event(payload, sig_header)
    rescue JSON::ParserError => e
      Rails.logger.error "Webhook JSON parse error: #{e.message}"
      return head :bad_request
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Webhook signature verification failed: #{e.message}"
      return head :bad_request
    end

    case event.type
    when "checkout.session.completed"
      SubscriptionManager.handle_checkout_completed(event.data.object)
    when "customer.subscription.updated"
      SubscriptionManager.handle_subscription_updated(event.data.object)
    when "customer.subscription.deleted"
      SubscriptionManager.handle_subscription_deleted(event.data.object)
    when "invoice.payment_failed"
      SubscriptionManager.handle_invoice_payment_failed(event.data.object)
    else
      Rails.logger.info "Unhandled Stripe event type: #{event.type}"
    end

    head :ok
  rescue StandardError => e
    Rails.logger.error "Webhook error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    head :internal_server_error
  end
end
