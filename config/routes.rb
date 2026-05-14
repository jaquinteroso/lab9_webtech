Rails.application.routes.draw do
  devise_for :users
  # Ruta principal
  root "owners#index"

  resources :owners
  resources :pets
  resources :vets
  resources :appointments do
    resources :treatments, only: [:new, :create, :edit, :update, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
