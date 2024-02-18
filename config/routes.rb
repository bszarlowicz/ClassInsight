Rails.application.routes.draw do
  resources :lessons
  devise_for :users
  root "lessons#index"
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
end
