Rails.application.routes.draw do
  root "lessons#index"
  resources :lessons
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users do
    get 'schedule', to: 'schedules#index'
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
