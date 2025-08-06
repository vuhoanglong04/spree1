class RolePolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    user.has_permission?('roles', 'index')
  end

  def show?
    user.has_permission?('roles', 'show')
  end

  def create?
    user.has_permission?('roles', 'create')
  end

  def update?
    user.has_permission?('roles', 'update')
  end

  def destroy?
    user.has_permission?('roles', 'destroy')
  end

  def authorized?
    user.has_permission?('roles', 'authorize')
  end
end
