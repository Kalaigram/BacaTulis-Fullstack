class ProfilesController < ApplicationController
  before_action :require_authentication

  def show
  end

  def edit
  end

  def update
    service = ProfileUpdater.call(current_user, profile_params)

    if service.success?
      redirect_to profile_path, notice: "Profil berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.expect(user: [ :name, :email_address, :password, :password_confirmation ])
  end
end
