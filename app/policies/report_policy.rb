class ReportPolicy < ApplicationPolicy
  def create?
    true
  end

  def index?
    admin?
  end

  def update?
    admin?
  end
end
