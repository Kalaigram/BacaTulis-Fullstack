class RegistrationCreator < ApplicationService
  attr_reader :user

  def initialize(params)
    @params = params
  end

  def call
    @user = User.new(@params)
    if @user.save
      SendWelcomeEmailJob.perform_later(@user.id)
    end
    self
  end

  def success?
    @user.persisted?
  end

  def errors
    @user.errors
  end
end
