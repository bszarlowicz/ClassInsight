Rails.application.routes.draw do
  root 'users#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users do
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
end
