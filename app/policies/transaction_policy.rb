class TransactionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    owner?
  end

  def create?
    true
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  private

  def owner?
    record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
