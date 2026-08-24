class CommentSerializer
  include JSONAPI::Serializer

  attributes :body, :created_at, :updated_at

  attribute :formatted_created_at do |comment|
    comment.created_at.iso8601
  end

  belongs_to :user
  belongs_to :post
end
