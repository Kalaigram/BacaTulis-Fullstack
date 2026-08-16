module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
    helper_method :current_user, :user_signed_in?
  end

  private

  def current_user
    Current.user
  end

  def user_signed_in?
    Current.user.present?
  end

  def authenticate_user
    if (session = Session.find_by(id: cookies.signed[:session_id]))
      Current.session = session
    else
      cookies.delete(:session_id)
    end
  end

  def require_authentication
    return if user_signed_in?

    redirect_to new_session_path, alert: "Silakan masuk terlebih dahulu."
  end

  def require_admin
    return if current_user&.admin?

    redirect_to root_path, alert: "Hanya admin yang bisa mengakses halaman ini."
  end

  def login(user)
    Current.session = user.sessions.create!
    cookies.signed[:session_id] = { value: Current.session.id, httponly: true, same_site: :lax }
  end

  def logout
    Current.session&.destroy
    cookies.delete(:session_id)
  end
end
