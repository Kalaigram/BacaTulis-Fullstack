class PostQuery
  PER_PAGE = 6

  attr_reader :user

  def initialize(user, scope: "mine")
    @user = user
    @scope = base_scope(scope)
  end

  def filtered(q: nil, status: nil, category_id: nil, tag_id: nil, paid: nil)
    @scope.order(created_at: :desc)
          .search(q)
          .by_status(status)
          .by_category(category_id)
          .by_tag(tag_id)
          .by_paid(paid)
  end

  def page(relation, page)
    relation.paginate(page, PER_PAGE)
  end

  def total(relation)
    relation.count
  end

  private

  def base_scope(scope)
    if @user.admin?
      scope == "mine" ? @user.posts : Post
    else
      case scope
      when "mine"
        @user.posts
      else
        Post.visible_to(@user)
      end
    end
  end
end
