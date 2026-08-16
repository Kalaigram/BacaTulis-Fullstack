ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # MySQL (via mysql2) rawan deadlock saat insert fixture paralel; jalankan seri.
    parallelize(workers: 0)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module SignInHelper
  def sign_in(user, password: "password")
    post session_path, params: { email_address: user.email_address, password: password }
    assert_redirected_to root_path
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end
