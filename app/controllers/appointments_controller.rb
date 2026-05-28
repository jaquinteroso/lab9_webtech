class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  def index
    @appointments = policy_scope(Appointment).includes(:pet, :vet)
  end

  def show
    authorize @appointment #
    @treatments = @appointment.treatments.with_rich_text_clinical_notes
  end

  def new
    @appointment = Appointment.new
    authorize @appointment #
  end

  def create
    @appointment = Appointment.new
    @appointment.assign_attributes(permitted_attributes(@appointment))

    if current_user.vet?
      @appointment.vet = current_user.vet
    elsif current_user.owner?
      pet_id = params.dig(:appointment, :pet_id)
      if current_user.owner.pets.exists?(id: pet_id)
        @appointment.pet_id = pet_id
      end
    end

    authorize @appointment #

    if @appointment.save
      redirect_to @appointment, notice: "Appointment was successfully scheduled."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @appointment #
  end

  def update
    authorize @appointment #
    if @appointment.update(permitted_attributes(@appointment))
      redirect_to @appointment, notice: "Appointment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @appointment #
    @appointment.destroy
    redirect_to appointments_url, notice: "Appointment was successfully cancelled."
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end
end
