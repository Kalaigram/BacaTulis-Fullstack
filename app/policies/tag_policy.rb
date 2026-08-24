class TagPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    admin?
  end

  def destroy?
    admin?
  end
end
