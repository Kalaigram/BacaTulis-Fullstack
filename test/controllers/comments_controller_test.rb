require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated user is redirected to sign in" do
    post post_comments_url(posts(:user_post)), params: { comment: { body: "Halo" } }
    assert_redirected_to new_session_url
  end

  test "user can comment on a post" do
    sign_in users(:user)
    assert_difference -> { Comment.count }, 1 do
      post post_comments_url(posts(:user_post)), params: { comment: { body: "Komentar baru" } }
    end
    assert_redirected_to post_path(posts(:user_post))
    assert_equal users(:user), Comment.last.user
  end

  test "blank comment is rejected" do
    sign_in users(:user)
    assert_no_difference -> { Comment.count } do
      post post_comments_url(posts(:user_post)), params: { comment: { body: "   " } }
    end
    assert_redirected_to post_path(posts(:user_post))
  end

  test "comment owner can destroy their comment" do
    sign_in users(:user)
    assert_difference -> { Comment.count }, -1 do
      delete comment_url(comments(:user_comment))
    end
    assert_redirected_to post_path(posts(:user_post))
  end

  test "user cannot destroy another user's comment" do
    sign_in users(:user)
    assert_no_difference -> { Comment.count } do
      delete comment_url(comments(:admin_comment))
    end
    assert_redirected_to post_path(posts(:user_post))
  end

  test "admin can destroy any comment" do
    sign_in users(:admin)
    assert_difference -> { Comment.count }, -1 do
      delete comment_url(comments(:user_comment))
    end
    assert_redirected_to post_path(posts(:user_post))
  end
end
