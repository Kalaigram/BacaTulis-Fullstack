Rails.application.routes.draw do
  root "dashboard#index"

  resource :session
  resource :registration, only: %i[new create]
  resource :profile, only: %i[show edit update]
  resources :posts do
    resources :comments, only: :create
  end
  resources :comments, only: :destroy
  resources :categories, except: :show
  resources :users, only: %i[index update destroy]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
