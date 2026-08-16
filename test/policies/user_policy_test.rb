require "test_helper"

class UserPolicyTest < ActiveSupport::TestCase
  test "admin can manage other users" do
    policy = UserPolicy.new(users(:admin), users(:user))
    assert policy.index?
    assert policy.update?
    assert policy.destroy?
  end

  test "admin cannot update or destroy their own account" do
    policy = UserPolicy.new(users(:admin), users(:admin))
    refute policy.update?
    refute policy.destroy?
  end

  test "regular user cannot manage users" do
    policy = UserPolicy.new(users(:user), users(:admin))
    refute policy.index?
    refute policy.update?
  end
end
