class PostsController < ApplicationController
  before_action :require_authentication
  before_action :set_post, only: %i[show edit update destroy]

  def index
    query = PostQuery.new(current_user, scope: params[:scope])
    filtered = query.filtered(q: params[:q], status: params[:status], category_id: params[:category_id])
    @total = query.total(filtered)
    @posts = query.page(filtered, params[:page])
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def edit
  end

  def create
    service = PostCreator.call(current_user, post_params)

    if service.success?
      redirect_to service.post, notice: "Post berhasil dibuat."
    else
      @post = service.post
      render :new, status: :unprocessable_entity
    end
  end

  def update
    service = PostUpdater.call(@post, post_params)

    if service.success?
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
    @post = Post.find(params[:id])
    return if PostPolicy.new(current_user, @post).show?

    raise ActiveRecord::RecordNotFound
  end

  def post_params
    params.expect(post: [ :title, :body, :status, :category_id ])
  end
end
