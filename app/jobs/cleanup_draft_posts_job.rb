class CleanupDraftPostsJob < ApplicationJob
  queue_as :default

  OLDER_THAN = 30.days

  def perform
    Post.draft.where("updated_at < ?", OLDER_THAN.ago).destroy_all
  end
end
