class SubscriptionPolicy < ApplicationPolicy
  def index?
    record.creator == user
  end

  def show?
    record.creator == user || record.subscriber == user
  end

  def create?
    user != record.creator
  end

  def cancel?
    record.subscriber == user
  end

  def reactivate?
    record.subscriber == user
  end
end
