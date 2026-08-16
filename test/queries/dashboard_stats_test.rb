require "test_helper"

class DashboardStatsTest < ActiveSupport::TestCase
  test "user stats are scoped to their own posts" do
    stats = DashboardStats.new(users(:user))
    assert_equal users(:user).posts.count, stats.post_count
    assert_equal users(:user).posts.draft.count, stats.draft_count
    assert_nil stats.user_count
  end

  test "admin stats include the global user count" do
    stats = DashboardStats.new(users(:admin))
    assert_equal Post.count, stats.post_count
    assert_equal User.count, stats.user_count
  end
end
