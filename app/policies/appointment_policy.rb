class AppointmentPolicy < ApplicationPolicy
  def show?
    user.admin? || is_involved? #
  end

  def create?
    user.admin? || is_involved? #
  end

  def new?
    create?
  end

  def update?
    user.admin? || is_involved? #
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || is_involved? #
  end

  def permitted_attributes
    if user.admin?
      [:date, :reason, :status, :pet_id, :vet_id]
    elsif user.vet?
      [:date, :reason, :status, :pet_id]
    elsif user.owner?
      [:date, :reason, :status, :vet_id]
    end
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all #
      elsif user.vet?
        scope.where(vet_id: user.vet&.id) 
      elsif user.owner?
        scope.joins(:pet).where(pets: { owner_id: user.owner&.id }) 
      else
        scope.none
      end
    end
  end

  private

  def is_involved?
    if user.vet?
      record.vet_id == user.vet&.id
    elsif user.owner?
      record.pet&.owner_id == user.owner&.id
    else
      false
    end
  end
end
