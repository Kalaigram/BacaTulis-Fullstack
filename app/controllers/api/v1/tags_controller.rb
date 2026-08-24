module Api
  module V1
    class TagsController < BaseController
      def index
        @tags = Tag.order(:name).includes(:posts)
        render json: TagSerializer.new(@tags).serializable_hash
      end
    end
  end
end
