class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  enum :status, { draft: 0, published: 1 }, default: :published
  enum :subscription_tier, { free: 0, basic: 1, premium: 2 }, default: :free

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
    rich_text_table = ActionText::RichText.table_name
    joins("LEFT JOIN #{rich_text_table} ON #{rich_text_table}.record_type = 'Post' AND #{rich_text_table}.record_id = posts.id AND #{rich_text_table}.name = 'body'")
      .where("posts.title LIKE :q OR #{rich_text_table}.body LIKE :q", q: like)
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
  scope :by_paid, ->(paid) {
    next all if paid.blank?

    where(paid: paid == "true")
  }
  scope :paid, -> { where(paid: true) }
  scope :free, -> { where(paid: false) }
  scope :visible_to, ->(user) {
    return published.free if user.nil?

    if user.admin?
      Post.all
    else
      subscribed_creator_ids = Subscription.active_for_creator(user).select(:subscriber_id)
      Post.where(paid: false, status: :published)
          .or(Post.where(user: user))
          .or(Post.where(paid: true, status: :published, user_id: subscribed_creator_ids))
    end
  }

  def paid?
    paid == true
  end

  def liked_by?(user)
    likes.exists?(user: user)
  end

  def bookmarked_by?(user)
    bookmarks.exists?(user: user)
  end

  def accessible_by?(user)
    return false unless published?
    return true unless paid?
    return true if user&.admin?
    return true if user == self.user
    return true if user&.subscribed_to?(self.user)

    false
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
