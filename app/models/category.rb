class Category < ApplicationRecord
  has_many :posts, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :parameterize_slug, if: -> { slug.blank? }

  def to_param
    slug
  end

  private

  def parameterize_slug
    self.slug = name.parameterize
  end
end
