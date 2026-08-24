class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true, uniqueness: true

  before_save { self.name = name.downcase.strip }
  before_create { self.slug = name.parameterize }

  scope :popular, -> { joins(:post_tags).group("tags.id").order("COUNT(post_tags.id) DESC").limit(10) }
end
