class ProfileUpdater < ApplicationService
  attr_reader :user

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    @user.update(profile_params)
    self
  end

  def success?
    @user.errors.empty?
  end

  def errors
    @user.errors
  end

  private

  def profile_params
    if @params[:password].blank?
      @params.except(:password, :password_confirmation)
    else
      @params
    end
  end
end
