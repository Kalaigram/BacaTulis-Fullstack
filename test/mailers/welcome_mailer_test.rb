require "test_helper"

class WelcomeMailerTest < ActionMailer::TestCase
  test "welcome email is delivered with the user details" do
    user = users(:user)
    email = WelcomeMailer.welcome_email(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "no-reply@baca-tulis.test" ], email.from
    assert_equal [ "user@example.com" ], email.to
    assert_equal "Selamat datang di BacaTulis!", email.subject
    assert_match "User Biasa", email.body.encoded
  end
end
