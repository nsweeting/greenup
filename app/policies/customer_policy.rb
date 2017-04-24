class CustomerPolicy < ApplicationPolicy
  def index?
    standard_policy(:read)
  end

  def create?
    standard_policy(:write)
  end

  def show?
    standard_policy(:read)
  end

  def update?
    standard_policy(:write)
  end

  def destroy?
    standard_policy(:delete)
  end
end
