class OwnerPolicy < ApplicationPolicy
  def show?
    # Admin y Vet pueden ver a todos. Owner solo puede ver su propio registro
    user.admin? || user.vet? || is_own_record? 
  end

  def create?
    # Solo el Admin puede crear dueños directamente
    user.admin? 
  end

  def new?
    create?
  end

  def update?
    # Admin puede editar a todos. Owner solo puede editar el suyo
    user.admin? || is_own_record? 
  end

  def edit?
    update?
  end

  def destroy?
    # Solo el Admin puede eliminar dueños
    user.admin? 
  end

  def permitted_attributes
    if user.admin?
      # El admin puede asignar o cambiar a qué usuario (user_id) pertenece este dueño
      [:first_name, :last_name, :email, :phone, :address, :user_id] 
    else
      # Los dueños solo pueden cambiar sus datos personales
      [:first_name, :last_name, :email, :phone, :address]
    end
  end

  class Scope < Scope
    def resolve
      if user.admin? || user.vet?
        scope.all # Admin y Vet ven la lista completa
      elsif user.owner?
        # Un Owner solo se ve a si mismo en el index
        scope.where(user_id: user.id) 
      else
        scope.none
      end
    end
  end

  private

  # Método para verificar si el registro pertenece al usuario actual
  def is_own_record?
    user.owner? && record.user_id == user.id
  end
end
