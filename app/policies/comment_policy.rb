class CommentPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    admin? || record.user_id == user&.id
  end
end
