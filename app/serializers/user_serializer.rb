class UserSerializer
  include JSONAPI::Serializer

  attributes :name, :email_address, :role, :created_at

  attribute :avatar_url do |user|
    user.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(user.avatar) : nil
  end
end
