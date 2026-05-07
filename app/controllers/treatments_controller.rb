class TreatmentsController < ApplicationController
  before_action :set_appointment 
  before_action :set_treatment, only: [:edit, :update, :destroy] 

  def new
    @treatment = @appointment.treatments.build 
  end

  def create
    @treatment = @appointment.treatments.build(treatment_params) 
    if @treatment.save
      redirect_to appointment_path(@appointment), notice: "Treatment added successfully." 
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def edit
  end

  def update
    if @treatment.update(treatment_params)
      redirect_to appointment_path(@appointment), notice: "Treatment updated successfully." 
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  def destroy
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

  def treatment_params
    params.require(:treatment).permit(:name, :medication, :dosage, :clinical_notes, :administered_at) 
  end
end
