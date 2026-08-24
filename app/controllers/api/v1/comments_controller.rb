module Api
  module V1
    class CommentsController < BaseController
      def index
        @post = Post.find(params[:post_id])
        @comments = @post.comments.includes(:user).recent.page(params[:page]).per(20)
        render json: CommentSerializer.new(@comments).serializable_hash
      end

      def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.build(comment_params.merge(user: current_api_user))

        if @comment.save
          render json: CommentSerializer.new(@comment).serializable_hash, status: :created
        else
          render json: { errors: @comment.errors }, status: :unprocessable_entity
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body)
      end
    end
  end
end
