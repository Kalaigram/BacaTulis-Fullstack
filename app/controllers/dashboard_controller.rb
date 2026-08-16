class DashboardController < ApplicationController
  before_action :require_authentication

  def index
    base = current_user.admin? ? Post : current_user.posts

    @post_count = base.count
    @published_count = base.published.count
    @draft_count = base.draft.count
    @recent_posts = base.order(created_at: :desc).limit(5)
    @user_count = User.count if current_user.admin?
    @recent_comments = Comment.recent.limit(5) if current_user.admin?
  end
end
