require "test_helper"

class SendWelcomeEmailJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test "sends the welcome email to an existing user" do
    user = users(:user)
    assert_emails 1 do
      SendWelcomeEmailJob.perform_now(user.id)
    end
  end

  test "is a no-op when the user no longer exists" do
    assert_no_emails do
      SendWelcomeEmailJob.perform_now(123_456_789)
    end
  end
end
