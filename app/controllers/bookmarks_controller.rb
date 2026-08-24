class BookmarksController < ApplicationController
  before_action :require_authentication

  def index
    @posts = current_user.bookmarked_posts.includes(:user, :category, :tags)
                         .order("bookmarks.created_at DESC")
  end

  def create
    @post = Post.find(params[:post_id])
    @bookmark = current_user.bookmarks.build(post: @post)

    if @bookmark.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: @post }
      end
    else
      redirect_back fallback_location: @post, alert: "Gagal bookmark post."
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @post = @bookmark.post
    @bookmark.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: posts_path }
    end
  end
end
