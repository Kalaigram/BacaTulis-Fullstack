class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def update?
    admin? && record != user
  end

  def destroy?
    admin? && record != user
  end
end
