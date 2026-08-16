require "test_helper"

class CategoryPolicyTest < ActiveSupport::TestCase
  test "admin can manage categories" do
    policy = CategoryPolicy.new(users(:admin), Category)
    assert policy.manage?
  end

  test "regular user cannot manage categories" do
    policy = CategoryPolicy.new(users(:user), Category)
    refute policy.manage?
  end
end
