class VetPolicy < ApplicationPolicy
  def show?
    # Todos los roles (Admin, Vet, Owner) pueden ver el perfil de un veterinario
    true
  end

  def create?
    # Solo el Admin puede crear nuevos veterinarios
    user.admin?
  end

  def new?
    create?
  end

  def update?
    # Admin puede editar a todos. El Vet solo puede editar su propio registro
    user.admin? || (user.vet? && record.user_id == user.id)
  end

  def edit?
    update?
  end

  def destroy?
    # Solo el Admin puede eliminar veterinarios
    user.admin?
  end

  def permitted_attributes
    if user.admin?
      # El admin puede reasignar cuentas de usuario
      [:first_name, :last_name, :email, :phone, :specialization, :user_id]
    else
      # Si un Vet edita su propio perfil, no puede cambiar su user_id
      [:first_name, :last_name, :email, :phone, :specialization]
    end
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
