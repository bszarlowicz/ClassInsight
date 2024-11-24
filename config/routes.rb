Rails.application.routes.draw do
  root 'users#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users do
    resources :lessons
    get 'schedule', to: 'schedules#index'
  end

  resources :teachers, only: [] do
    member do
      post 'create_student'
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
