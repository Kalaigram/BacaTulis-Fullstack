class WelcomeMailerPreview < ActionMailer::Preview
  def welcome_email
    WelcomeMailer.welcome_email(User.first)
  end
end
