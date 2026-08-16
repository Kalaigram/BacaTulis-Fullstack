class ProfilesController < ApplicationController
  before_action :require_authentication

  def show
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: "Profil berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    user_params = params.expect(user: [ :name, :email_address, :password, :password_confirmation ])
    user_params[:password].blank? ? user_params.except(:password, :password_confirmation) : user_params
  end
end
