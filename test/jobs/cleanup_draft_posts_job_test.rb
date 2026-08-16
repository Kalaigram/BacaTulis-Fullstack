require "test_helper"

class CleanupDraftPostsJobTest < ActiveJob::TestCase
  test "deletes stale drafts" do
    stale = posts(:user_draft)
    stale.update_columns(updated_at: 45.days.ago)

    assert_difference -> { Post.count }, -1 do
      CleanupDraftPostsJob.perform_now
    end

    refute Post.exists?(stale.id)
  end

  test "keeps recent drafts" do
    fresh = posts(:user_draft)

    assert_no_difference -> { Post.count } do
      CleanupDraftPostsJob.perform_now
    end

    assert Post.exists?(fresh.id)
  end
end
