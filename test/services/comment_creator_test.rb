require "test_helper"

class CommentCreatorTest < ActiveJob::TestCase
  test "creates a comment" do
    assert_difference -> { Comment.count }, 1 do
      CommentCreator.call(posts(:user_post), users(:user), "Isi komentar baru")
    end
  end

  test "rejects a blank body" do
    service = CommentCreator.call(posts(:user_post), users(:user), "   ")
    refute service.success?
  end

  test "enqueues a notification for the post author" do
    assert_enqueued_with(job: SendCommentNotificationJob) do
      CommentCreator.call(posts(:user_post), users(:admin), "Halo dari admin")
    end
  end

  test "does not notify the author of their own comment" do
    assert_no_enqueued_jobs only: SendCommentNotificationJob do
      CommentCreator.call(posts(:user_post), users(:user), "Komentar sendiri")
    end
  end
end
