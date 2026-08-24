class BookmarkPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    record.user == user
  end
end
