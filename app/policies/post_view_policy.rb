class PostViewPolicy < ApplicationPolicy
  def create?
    true
  end

  def index?
    admin?
  end
end
