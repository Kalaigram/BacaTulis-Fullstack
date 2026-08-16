class UsersController < ApplicationController
  before_action :require_authentication
  before_action :require_admin
  before_action :set_user, only: [ :update, :destroy ]

  def index
    @users = User.order(:email_address)
  end

  def update
    role = params.dig(:user, :role)

    if !UserPolicy.new(current_user, @user).update?
      redirect_to users_path, alert: "Tidak bisa mengubah peran akun sendiri."
    elsif @user.admin? && User.admin.count == 1 && role != "admin"
      redirect_to users_path, alert: "Setidaknya harus ada satu admin."
    elsif @user.update(user_params)
      redirect_to users_path, notice: "Peran #{@user.email_address} diperbarui."
    else
      redirect_to users_path, alert: "Gagal memperbarui peran."
    end
  end

  def destroy
    if !UserPolicy.new(current_user, @user).destroy?
      redirect_to users_path, alert: "Tidak bisa menghapus akun sendiri."
    elsif @user.destroy
      redirect_to users_path, notice: "Akun #{@user.email_address} dihapus."
    else
      redirect_to users_path, alert: "Gagal menghapus akun."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.expect(user: [ :role ])
  end
end
