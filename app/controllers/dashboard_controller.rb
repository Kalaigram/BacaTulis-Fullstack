class DashboardController < ApplicationController
  before_action :require_authentication

  def index
    stats = DashboardStats.new(current_user)

    @post_count = stats.post_count
    @published_count = stats.published_count
    @draft_count = stats.draft_count
    @recent_posts = stats.recent_posts
    @user_count = stats.user_count
    @recent_comments = stats.recent_comments
  end
end
