class SessionsController < ApplicationController
  def new
  end

  def create
    if (user = User.authenticate_by(email_address: params[:email_address], password: params[:password]))
      login(user)
      redirect_to root_path, notice: "Berhasil masuk. Selamat datang, #{user.email_address}!"
    else
      redirect_to new_session_path, alert: "Email atau password salah."
    end
  end

  def destroy
    logout
    redirect_to new_session_path, notice: "Berhasil keluar."
  end
end
