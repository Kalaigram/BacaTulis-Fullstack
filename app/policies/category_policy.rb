class CategoryPolicy < ApplicationPolicy
  def manage?
    admin?
  end
end
