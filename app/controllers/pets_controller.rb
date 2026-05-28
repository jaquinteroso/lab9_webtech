class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update, :destroy]

  def index
    @pets = policy_scope(Pet).includes(:owner)
  end

  def show
    authorize @pet #
  end

  def new
    @pet = Pet.new
    authorize @pet #
  end

  def create
    @pet = Pet.new
    authorize @pet #

    @pet.assign_attributes(permitted_attributes(@pet))

    if current_user.owner?
      @pet.owner = current_user.owner
    end

    if @pet.save
      redirect_to @pet, notice: "Pet was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @pet #
  end

  def update
    authorize @pet #
    
    if @pet.update(permitted_attributes(@pet)) #
      redirect_to @pet, notice: "Pet was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @pet #
    @pet.destroy
    redirect_to pets_url, notice: "Pet was successfully destroyed."
  end

  private

  def set_pet
    @pet = Pet.find(params[:id])
  end
end
