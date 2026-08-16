class CommentQuery
  attr_reader :scope

  def initialize(scope = Comment)
    @scope = scope
  end

  def recent(limit: 5)
    @scope.recent.limit(limit)
  end

  def for_post(post, limit: 50)
    @scope.where(post: post).recent.limit(limit)
  end

  def by_user(user, limit: 5)
    @scope.where(user: user).recent.limit(limit)
  end

  def count
    @scope.count
  end
end
