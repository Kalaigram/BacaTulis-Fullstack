class SendCommentNotificationJob < ApplicationJob
  queue_as :default

  def perform(comment_id)
    comment = Comment.find_by(id: comment_id)
    CommentMailer.notification(comment).deliver_now if comment
  end
end
