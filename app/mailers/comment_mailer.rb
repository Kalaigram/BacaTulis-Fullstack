class CommentMailer < ApplicationMailer
  def notification(comment)
    @comment = comment
    @post = comment.post
    @author = @post.user
    mail to: @author.email_address, subject: "Komentar baru di \"#{@post.title}\""
  end
end
