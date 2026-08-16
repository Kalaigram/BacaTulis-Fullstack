class PostsController < ApplicationController
  before_action :require_authentication
  before_action :set_post, only: %i[show edit update destroy]

  PER_PAGE = 6

  def index
    scope = current_user.admin? && params[:scope] != "mine" ? Post : current_user.posts
    @posts = scope.order(created_at: :desc).search(params[:q]).by_status(params[:status]).by_category(params[:category_id])
    @total = @posts.count
    @posts = @posts.paginate(params[:page], PER_PAGE)
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post berhasil dibuat."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post berhasil dihapus."
  end

  private

  def set_post
    @post = current_user.admin? ? Post.find(params[:id]) : current_user.posts.find(params[:id])
  end

  def post_params
    params.expect(post: [ :title, :body, :status, :category_id ])
  end
end
