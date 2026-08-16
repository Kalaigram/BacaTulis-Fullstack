require "test_helper"

class PostPolicyTest < ActiveSupport::TestCase
  test "admin can manage any post" do
    policy = PostPolicy.new(users(:admin), posts(:user_post))
    assert policy.show?
    assert policy.update?
    assert policy.destroy?
  end

  test "author can manage their own post" do
    policy = PostPolicy.new(users(:user), posts(:user_post))
    assert policy.show?
    assert policy.update?
  end

  test "user cannot manage someone else's post" do
    policy = PostPolicy.new(users(:user), posts(:admin_post))
    refute policy.show?
    refute policy.update?
    refute policy.destroy?
  end
end
