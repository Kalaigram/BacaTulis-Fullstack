class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  enum :status, { draft: 0, published: 1 }, default: :published

  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user
  has_many :post_views, dependent: :destroy

  has_one_attached :hero_image
  has_many_attached :images

  has_rich_text :body

  validates :title, presence: true
  validate :body_present, on: :create
  validate :hero_image_content_type
  validate :hero_image_size

  scope :search, ->(term) {
    next all if term.blank?

    like = "%#{sanitize_sql_like(term)}%"
    where("title LIKE :q OR body LIKE :q", q: like)
  }
  scope :by_status, ->(status) {
    case status.to_s
    when "published" then published
    when "draft" then draft
    else all
    end
  }
  scope :by_category, ->(category_id) {
    next all if category_id.blank?

    where(category_id: category_id)
  }
  scope :paginate, ->(page, per_page) {
    offset(([ page.to_i, 1 ].max - 1) * per_page).limit(per_page)
  }
  scope :by_tag, ->(tag_id) {
    next all if tag_id.blank?

    joins(:post_tags).where(post_tags: { tag_id: tag_id })
  }

  def liked_by?(user)
    likes.exists?(user: user)
  end

  def bookmarked_by?(user)
    bookmarks.exists?(user: user)
  end

  private

  def body_present
    errors.add(:body, "tidak boleh kosong") unless body.present?
  end

  def hero_image_content_type
    if hero_image.attached? && !hero_image.image?
      errors.add(:hero_image, "harus berupa gambar")
    end
  end

  def hero_image_size
    if hero_image.attached? && hero_image.byte_size > 5.megabytes
      errors.add(:hero_image, "ukuran maksimal 5MB")
    end
  end
end
