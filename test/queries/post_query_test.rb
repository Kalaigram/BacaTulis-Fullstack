require "test_helper"

class PostQueryTest < ActiveSupport::TestCase
  test "admin with all scope sees every post" do
    query = PostQuery.new(users(:admin), scope: "all")
    assert_equal Post.count, query.filtered.count
  end

  test "user sees only their own posts" do
    query = PostQuery.new(users(:user))
    assert_equal users(:user).posts.pluck(:id).sort, query.filtered.pluck(:id).sort
  end

  test "filters by status" do
    query = PostQuery.new(users(:user))
    drafts = query.filtered(status: "draft")
    assert_equal [ posts(:user_draft).id ], drafts.pluck(:id)
  end

  test "filters by search term" do
    query = PostQuery.new(users(:user))
    found = query.filtered(q: "rahasia")
    assert_equal [ posts(:user_draft).id ], found.pluck(:id)
  end

  test "paginates results" do
    query = PostQuery.new(users(:user))
    page_two = query.page(users(:user).posts.order(created_at: :desc), 2)
    assert_empty page_two
  end
end
