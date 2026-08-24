class TagSerializer
  include JSONAPI::Serializer

  attributes :name, :slug, :created_at

  has_many :posts
end
