class PetPolicy < ApplicationPolicy
  def show?
    # Admin y Vet ven todas. Owner solo ve sus propias mascotas
    user.admin? || user.vet? || is_own_pet?
  end

  def create?
    # Vet no puede crear mascotas
    user.admin? || user.owner?
  end

  def new?
    create?
  end

  def update?
    user.admin? || is_own_pet?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || is_own_pet?
  end

  def permitted_attributes
    if user.admin?
      # El admin puede elegir a qué dueño pertenece la mascota en el formulario
      [:name, :species, :breed, :date_of_birth, :weight, :photo, :owner_id]
    else
      # El owner no recibe el parámetro :owner_id, evitando que lo falsifique (forge)
      [:name, :species, :breed, :date_of_birth, :weight, :photo]
    end
  end

  class Scope < Scope
    def resolve
      if user.admin? || user.vet?
        scope.all # Admin y Vet ven la lista completa
      elsif user.owner?
        # Owner solo ve mascotas cuyo owner asociado tenga su user_id
        scope.joins(:owner).where(owners: { user_id: user.id })
      else
        scope.none
      end
    end
  end

  private

  # Verifica si la mascota pertenece al dueño asociado a este usuario actual
  def is_own_pet?
    user.owner? && record.owner&.user_id == user.id
  end
end
