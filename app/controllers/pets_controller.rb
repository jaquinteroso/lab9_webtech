class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update, :destroy]

  def index
    @pets = Pet.includes(:owner).all
  end

  def show
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    if @pet.save
      redirect_to @pet, notice: "Pet was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @pet.update(pet_params)
      redirect_to @pet, notice: "Pet was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet.destroy
    redirect_to pets_url, notice: "Pet was successfully destroyed."
  end

  private

  def set_pet
    @pet = Pet.find(params[:id])
  end

  def pet_params
    params.require(:pet).permit(:name, :species, :breed, :weight, :date_of_birth, :owner_id, :photo) 
  end
end
