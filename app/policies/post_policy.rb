class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    admin? || record.user_id == user&.id
  end

  def create?
    true
  end

  def update?
    show?
  end

  def destroy?
    show?
  end
end
