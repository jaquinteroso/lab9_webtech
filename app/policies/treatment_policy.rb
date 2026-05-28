class TreatmentPolicy < ApplicationPolicy
  def create?
    # El Vet solo puede crear si el vet_id de la cita coincide con su propio ID de veterinario
    user.admin? || (user.vet? && record.appointment.vet_id == user.vet&.id)
  end

  def new?
    create?
  end

  def update?
    user.admin? || (user.vet? && record.appointment.vet_id == user.vet&.id) #
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || (user.vet? && record.appointment.vet_id == user.vet&.id) #
  end

  def permitted_attributes
    if user.admin?
      [:name, :medication, :dosage, :clinical_notes, :administered_at, :appointment_id] #
    else
      # El Vet no puede manipular a qué cita pertenece este tratamiento
      [:name, :medication, :dosage, :clinical_notes, :administered_at]
    end
  end
end
