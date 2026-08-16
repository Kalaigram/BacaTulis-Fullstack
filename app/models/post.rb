class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

  enum :status, { draft: 0, published: 1 }, default: :published

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

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
end
