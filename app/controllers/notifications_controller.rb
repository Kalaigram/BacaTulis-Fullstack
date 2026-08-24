class NotificationsController < ApplicationController
  before_action :require_authentication

  def index
    @notifications = current_user.notifications.recent.includes(:actor, :notifiable)
    @unread_count = current_user.notifications.unread.count
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)
    redirect_to notifications_path, notice: "Semua notifikasi ditandai sudah dibaca."
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!
    redirect_to polymorphic_path(@notification.notifiable)
  end
end
