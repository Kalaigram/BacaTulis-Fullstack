require "test_helper"

class CommentQueryTest < ActiveSupport::TestCase
  test "returns recent comments newest first" do
    query = CommentQuery.new.recent(limit: 5)
    assert_equal 3, query.size
    assert_equal Comment.order(created_at: :desc).limit(5).pluck(:id), query.pluck(:id)
  end

  test "filters comments for a specific post" do
    query = CommentQuery.new.for_post(posts(:user_post))
    assert_equal [ comments(:user_comment).id, comments(:admin_comment).id ].sort, query.pluck(:id).sort
  end

  test "filters comments by user" do
    query = CommentQuery.new.by_user(users(:user))
    assert_equal [ comments(:user_comment).id, comments(:user_comment_on_admin_post).id ].sort, query.pluck(:id).sort
  end
end
