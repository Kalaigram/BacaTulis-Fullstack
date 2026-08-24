class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if admin?
    return true if record.user == user
    return false unless record.published?
    return true unless record.paid?
    return true if user&.subscribed_to?(record.user)

    false
  end

  def create?
    true
  end

  def update?
    admin? || record.user == user
  end

  def destroy?
    admin? || record.user == user
  end
end
