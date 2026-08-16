require "test_helper"

class RegistrationCreatorTest < ActiveJob::TestCase
  test "creates a user and enqueues a welcome email" do
    assert_difference -> { User.count }, 1 do
      assert_enqueued_with(job: SendWelcomeEmailJob) do
        RegistrationCreator.call(name: "Budi",
                                 email_address: "budi@example.com",
                                 password: "password",
                                 password_confirmation: "password")
      end
    end
  end

  test "rejects invalid data" do
    service = RegistrationCreator.call(name: "",
                                       email_address: "budi@example.com",
                                       password: "password",
                                       password_confirmation: "nope")
    refute service.success?
  end
end
