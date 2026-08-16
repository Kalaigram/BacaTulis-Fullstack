class WelcomeMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail to: user.email_address, subject: "Selamat datang di BacaTulis!"
  end
end
