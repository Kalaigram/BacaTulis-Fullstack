require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "default role is user" do
    user = User.new(email_address: "test@example.com", password: "password")
    assert_equal "user", user.role
    assert user.user?
    assert_not user.admin?
  end

  test "admin role is recognized" do
    assert users(:admin).admin?
  end

  test "email address is normalized" do
    user = User.create!(email_address: "  Test@Example.com ", password: "password")
    assert_equal "test@example.com", user.email_address
  end

  test "email address must be unique" do
    user = User.new(email_address: users(:admin).email_address, password: "password")
    assert_not user.valid?
    assert user.errors[:email_address].any?
  end

  test "has_secure_password authenticates correctly" do
    assert users(:admin).authenticate("password")
    assert_not users(:admin).authenticate("salah")
  end
end
