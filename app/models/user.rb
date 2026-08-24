class User < ApplicationRecord
  has_secure_password
  has_secure_token :api_token

  enum :role, { user: 0, admin: 1 }, default: :user

  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_posts, through: :bookmarks, source: :post
  has_many :notifications, dependent: :destroy
  has_many :reports, foreign_key: :reporter_id, dependent: :destroy

  has_one_attached :avatar

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true

  def avatar_variant(size)
    avatar.variant(resize_to_limit: [ size, size ])
  end

  def regenerate_api_token!
    update!(api_token: SecureRandom.hex(32))
  end
end
