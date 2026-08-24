class SubscriptionsController < ApplicationController
  before_action :require_authentication
  before_action :ensure_stripe_configured, only: %i[new create]

  def new
    @basic_price_id = StripeService.basic_price_id
    @premium_price_id = StripeService.premium_price_id
    @basic_amount = 500
    @premium_amount = 1500
  end

  def create
    creator = User.find(params[:creator_id])
    price_id = params[:price_id]

    unless [ StripeService.basic_price_id, StripeService.premium_price_id ].include?(price_id)
      redirect_to subscriptions_new_path(creator_id: creator.id), alert: "Invalid plan selected."
      return
    end

    result = SubscriptionManager.subscribe(creator, current_user, price_id)

    redirect_to result[:url], allow_other_host: true
  rescue SubscriptionManager::Error => e
    redirect_to subscriptions_new_path(creator_id: params[:creator_id]), alert: e.message
  end

  def success
    session_id = params[:session_id]

    if session_id.present?
      begin
        stripe_session = Stripe::Checkout::Session.retrieve(session_id)

        if stripe_session.payment_status == "paid"
          SubscriptionManager.handle_checkout_completed(stripe_session)
          flash[:notice] = "Berhasil berlangganan! Sekarang Anda bisa mengakses konten premium."
        else
          flash[:alert] = "Pembayaran belum selesai. Silakan coba lagi."
        end
      rescue Stripe::StripeError => e
        Rails.logger.error "Stripe session error: #{e.message}"
        flash[:alert] = "Terjadi kesalahan verifikasi. Hubungi dukungan jika masalah berlanjut."
      end
    end

    redirect_to root_path
  end

  def portal
    unless current_user.stripe_customer_id.present?
      redirect_to profile_path, alert: "Anda belum memiliki langganan aktif."
      return
    end

    session = StripeService.create_portal_session(
      current_user.stripe_customer_id,
      profile_url
    )

    redirect_to session.url, allow_other_host: true
  end

  private

  def ensure_stripe_configured
    unless StripeService.configured?
      redirect_to root_path, alert: "Fitur langganan belum tersedia. Hubungi admin."
    end
  end
end
