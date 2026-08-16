class CommentCreator < ApplicationService
  attr_reader :comment

  def initialize(post, user, body)
    @post = post
    @user = user
    @body = body
  end

  def call
    @comment = @post.comments.build(user: @user, body: @body)
    @comment.save
    notify_author if @comment.persisted?
    self
  end

  def success?
    @comment.persisted?
  end

  def errors
    @comment.errors
  end

  private

  def notify_author
    return if @post.user_id == @user.id

    SendCommentNotificationJob.perform_later(@comment.id)
  end
end
