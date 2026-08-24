class LikesController < ApplicationController
  before_action :require_authentication

  def create
    @post = Post.find(params[:post_id])
    @like = current_user.likes.build(post: @post)

    if @like.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: @post }
      end
    else
      redirect_back fallback_location: @post, alert: "Gagal menyukai post."
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @post = @like.post
    @like.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: @post }
    end
  end
end
