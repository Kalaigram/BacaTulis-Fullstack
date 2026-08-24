class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: :likes_count

  validates :user_id, uniqueness: { scope: :post_id, message: "sudah menyukai post ini" }

  after_create :notify_post_owner
  after_destroy :remove_notification

  private

  def notify_post_owner
    return if user == post.user

    Notification.create(
      user: post.user,
      actor: user,
      action: "liked",
      notifiable: post
    )
  end

  def remove_notification
    Notification.find_by(
      user: post.user,
      actor: user,
      action: "liked",
      notifiable: post
    )&.destroy
  end
end
