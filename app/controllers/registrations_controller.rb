class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    service = RegistrationCreator.call(registration_params)

    if service.success?
      login(service.user)
      redirect_to root_path, notice: "Akun berhasil dibuat. Selamat datang!"
    else
      @user = service.user
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.expect(user: [ :name, :email_address, :password, :password_confirmation ])
  end
end
