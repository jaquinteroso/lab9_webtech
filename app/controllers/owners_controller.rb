class OwnersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_owner, only: [:show, :edit, :update, :destroy]

  def index
    @owners = Owner.includes(:pets).all
  end

  def show
  end

  def new
    @owner = Owner.new
  end

  def create
    @owner = Owner.new(owner_params)
    if @owner.save
      redirect_to @owner, notice: "Owner was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @owner.update(owner_params)
      redirect_to @owner, notice: "Owner was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @owner.destroy
    redirect_to owners_url, notice: "Owner was successfully destroyed."
  end

  private

  def set_owner
    @owner = Owner.find(params[:id])
  end

  def owner_params
    params.require(:owner).permit(:first_name, :last_name, :email, :phone, :address)
  end

end
