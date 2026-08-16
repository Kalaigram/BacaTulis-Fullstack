class PostQuery
  PER_PAGE = 6

  attr_reader :user

  def initialize(user, scope: "mine")
    @user = user
    @scope = user.admin? && scope != "mine" ? Post : user.posts
  end

  def filtered(q: nil, status: nil, category_id: nil)
    @scope.order(created_at: :desc)
          .search(q)
          .by_status(status)
          .by_category(category_id)
  end

  def page(relation, page)
    relation.paginate(page, PER_PAGE)
  end

  def total(relation)
    relation.count
  end
end
