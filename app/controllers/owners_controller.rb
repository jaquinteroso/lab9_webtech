class OwnersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_after_action :verify_policy_scoped, only: [:index], unless: :user_signed_in?

  before_action :set_owner, only: [:show, :edit, :update, :destroy]

  def index
    if user_signed_in?
      @owners = policy_scope(Owner).includes(:pets) 
    else
      @owners = Owner.includes(:pets).all
    end
  end

  def show
    authorize @owner #
  end

  def new
    @owner = Owner.new
    authorize @owner #
  end

  def create
    @owner = Owner.new
    authorize @owner #
    
    @owner.assign_attributes(permitted_attributes(@owner)) 

    if @owner.save
      redirect_to @owner, notice: "Owner was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @owner #
  end

  def update
    authorize @owner #
    
    if @owner.update(permitted_attributes(@owner)) #
      redirect_to @owner, notice: "Owner was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @owner #
    @owner.destroy
    redirect_to owners_url, notice: "Owner was successfully destroyed."
  end

  private

  def set_owner
    @owner = Owner.find(params[:id])
  end
end
