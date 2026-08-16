class DashboardStats
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def base
    @base ||= user.admin? ? Post : user.posts
  end

  def post_count
    base.count
  end

  def published_count
    base.published.count
  end

  def draft_count
    base.draft.count
  end

  def user_count
    User.count if user.admin?
  end

  def recent_posts
    base.order(created_at: :desc).limit(5)
  end

  def recent_comments
    Comment.recent.limit(5) if user.admin?
  end
end
