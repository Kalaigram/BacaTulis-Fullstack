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

  test "user can see free published posts from others" do
    policy = PostPolicy.new(users(:user), posts(:admin_post))
    assert policy.show?
  end

  test "user cannot manage someone else's post" do
    policy = PostPolicy.new(users(:user), posts(:admin_post))
    refute policy.update?
    refute policy.destroy?
  end

  test "user cannot see draft posts from others" do
    policy = PostPolicy.new(users(:user), posts(:admin_draft))
    refute policy.show?
  end

  test "user can see their own draft posts" do
    policy = PostPolicy.new(users(:user), posts(:user_draft))
    assert policy.show?
  end
end
