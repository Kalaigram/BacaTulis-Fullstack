class CommentsController < ApplicationController
  before_action :require_authentication
  before_action :set_post, only: :create
  before_action :set_comment, only: :destroy

  def create
    comment = @post.comments.build(comment_params.merge(user: current_user))

    if comment.save
      redirect_to @post, notice: "Komentar ditambahkan."
    else
      redirect_to @post, alert: "Komentar tidak boleh kosong."
    end
  end

  def destroy
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      redirect_to @comment.post, notice: "Komentar dihapus."
    else
      redirect_to @comment.post, alert: "Tidak bisa menghapus komentar orang lain."
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.expect(comment: [ :body ])
  end
end
