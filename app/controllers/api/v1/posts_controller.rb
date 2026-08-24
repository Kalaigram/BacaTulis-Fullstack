module Api
  module V1
    class PostsController < BaseController
      def index
        @posts = Post.published.includes(:user, :category, :tags)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(params[:per_page] || 20)

        render json: PostSerializer.new(@posts).serializable_hash
      end

      def show
        @post = Post.published.find(params[:id])
        render json: PostSerializer.new(@post, include: [ :user, :tags, :category ]).serializable_hash
      end

      def create
        @post = current_api_user.posts.build(post_params)

        if @post.save
          render json: PostSerializer.new(@post).serializable_hash, status: :created
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      def update
        @post = current_api_user.posts.find(params[:id])

        if @post.update(post_params)
          render json: PostSerializer.new(@post).serializable_hash
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @post = current_api_user.posts.find(params[:id])
        @post.destroy
        head :no_content
      end

      private

      def post_params
        params.require(:post).permit(:title, :body, :status, :category_id, tag_ids: [])
      end
    end
  end
end
