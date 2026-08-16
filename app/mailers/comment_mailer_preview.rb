class CommentMailerPreview < ActionMailer::Preview
  def notification
    CommentMailer.notification(Comment.first)
  end
end
