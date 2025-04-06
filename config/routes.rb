Rails.application.routes.draw do
  # root 'dashboard#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users do
    resources :notes
    resources :lessons do
      get :add_attachments
      member do
        delete :remove_attachment
      end
      resources :topics, only: [:new, :create, :destroy]
    end
    get 'schedule', to: 'schedules#index'
  end

  resources :conversations do
    resources :messages
  end

  resources :reports
  resources :students, only: [:index, :show, :new, :create, :edit, :update]
  resources :teachers, only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show] do
        resources :lessons, only: [:show]
        resources :notes, only: [:create]
      end
    end
  end

  get 'dashboard', to: 'dashboard#index'
  get 'landing', to: 'landing#index'
  root 'landing#index'
end
