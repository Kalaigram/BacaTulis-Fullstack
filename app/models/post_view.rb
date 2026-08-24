class PostView < ApplicationRecord
  belongs_to :post, counter_cache: :views_count
  belongs_to :user, optional: true

  after_create :increment_views_count

  scope :today, -> { where(viewed_at: Date.current.all_day) }
  scope :this_week, -> { where(viewed_at: 1.week.ago..) }
  scope :this_month, -> { where(viewed_at: 1.month.ago..) }

  private

  def increment_views_count
    Post.where(id: post_id).update_all("views_count = views_count + 1")
  end
end
