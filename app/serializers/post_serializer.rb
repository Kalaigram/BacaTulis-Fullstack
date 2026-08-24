class PostSerializer
  include JSONAPI::Serializer

  attributes :title, :body, :status, :created_at, :updated_at,
             :likes_count, :comments_count, :views_count

  attribute :formatted_created_at do |post|
    post.created_at.iso8601
  end

  belongs_to :user
  belongs_to :category
  has_many :tags
end
