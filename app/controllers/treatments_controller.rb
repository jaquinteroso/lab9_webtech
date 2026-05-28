class TreatmentsController < ApplicationController
  before_action :set_appointment 
  before_action :set_treatment, only: [:edit, :update, :destroy] 

  def new
    @treatment = @appointment.treatments.build 
    authorize @treatment # Verificamos permisos antes de mostrar el formulario
  end

  def create
    @treatment = @appointment.treatments.build
    
    @treatment.assign_attributes(permitted_attributes(@treatment)) 
    
    authorize @treatment # Verificamos si el Vet realmente es el encargado de esta cita

    if @treatment.save
      redirect_to appointment_path(@appointment), notice: "Treatment added successfully." 
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def edit
    authorize @treatment #
  end

  def update
    authorize @treatment #
    
    if @treatment.update(permitted_attributes(@treatment))
      redirect_to appointment_path(@appointment), notice: "Treatment updated successfully." 
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  def destroy
    authorize @treatment #
    @treatment.destroy
    redirect_to appointment_path(@appointment), notice: "Treatment was successfully removed." 
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:appointment_id]) 
  end

  def set_treatment
    @treatment = @appointment.treatments.find(params[:id]) 
  end
end
