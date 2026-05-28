class VetsController < ApplicationController
  before_action :set_vet, only: [:show, :edit, :update, :destroy]

  def index
    @vets = policy_scope(Vet)
  end

  def show
    authorize @vet #
  end

  def new
    @vet = Vet.new
    authorize @vet #
  end

  def create
    @vet = Vet.new
    authorize @vet #

    @vet.assign_attributes(permitted_attributes(@vet))

    if @vet.save
      redirect_to @vet, notice: "Vet was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @vet #
  end

  def update
    authorize @vet #
    
    if @vet.update(permitted_attributes(@vet))
      redirect_to @vet, notice: "Vet was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @vet #
    @vet.destroy
    redirect_to vets_url, notice: "Vet was successfully destroyed."
  end

  private

  def set_vet
    @vet = Vet.find(params[:id])
  end
end
