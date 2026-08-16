class SendWelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    WelcomeMailer.welcome_email(user).deliver_now if user
  end
end
