Rails.application.routes.draw do
  root 'users#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users do
    resources :lessons do
      get :add_attachments
      resources :topics, only: [:new, :create, :destroy]
    end
    get 'schedule', to: 'schedules#index'
  end

  # resources :teachers, only: [] do
  # end
  resources :students, only: [:index, :show, :new, :create, :edit, :update]

  get "up" => "rails/health#show", as: :rails_health_check
end
