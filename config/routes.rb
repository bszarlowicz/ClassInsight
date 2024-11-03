Rails.application.routes.draw do
  root 'users#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users do
    get 'schedule', to: 'schedules#index'
    resources :lessons
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
