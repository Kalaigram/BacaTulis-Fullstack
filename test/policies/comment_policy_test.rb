require "test_helper"

class CommentPolicyTest < ActiveSupport::TestCase
  test "comment author can destroy their own comment" do
    policy = CommentPolicy.new(users(:user), comments(:user_comment))
    assert policy.destroy?
  end

  test "admin can destroy any comment" do
    policy = CommentPolicy.new(users(:admin), comments(:user_comment))
    assert policy.destroy?
  end

  test "user cannot destroy someone else's comment" do
    policy = CommentPolicy.new(users(:user), comments(:admin_comment))
    refute policy.destroy?
  end
end
