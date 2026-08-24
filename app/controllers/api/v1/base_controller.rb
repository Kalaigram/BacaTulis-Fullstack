module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_api_user

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable

      private

      def authenticate_api_user
        @current_api_user = User.find_by(api_token: request.headers["Authorization"]&.split(" ")&.last)
        render json: { error: "Unauthorized" }, status: :unauthorized unless @current_api_user
      end

      def current_api_user
        @current_api_user
      end

      def not_found
        render json: { error: "Not found" }, status: :not_found
      end

      def unprocessable(exception)
        render json: { errors: exception.record.errors }, status: :unprocessable_entity
      end
    end
  end
end
