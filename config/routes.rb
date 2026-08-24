Rails.application.routes.draw do
  root "pages#landing"

  get "dashboard", to: "dashboard#index", as: :dashboard

  resource :session
  resource :registration, only: %i[new create]
  resource :profile, only: %i[show edit update]

  resources :posts do
    resources :comments, only: :create
    resources :likes, only: %i[create destroy]
    resources :bookmarks, only: %i[create destroy]
    resources :reports, only: :create
  end

  resources :comments, only: :destroy do
    resources :reports, only: :create
  end

  resources :categories, except: :show
  resources :tags, only: %i[index create destroy]
  resources :bookmarks, only: :index
  resources :notifications, only: %i[index] do
    collection do
      patch :mark_all_as_read
    end
    member do
      patch :mark_as_read
    end
  end
  resources :reports, only: :create
  resources :users, only: %i[index update destroy]

  resources :subscriptions, only: %i[new create] do
    get :success, on: :collection
    get :portal, on: :collection
  end

  namespace :creator do
    resources :subscriptions, only: %i[index show]
    resources :analytics, only: :index
  end

  namespace :admin do
    resources :reports, only: %i[index update]
    resources :analytics, only: :index
    get "analytics/post/:id", to: "analytics#post", as: :post_analytics
  end

  namespace :api do
    namespace :v1 do
      resources :posts, only: %i[index show create update destroy]
      resources :comments, only: %i[index create]
      resources :tags, only: :index
      get "me", to: "users#me"
    end
  end

  post "webhooks/stripe", to: "webhooks#stripe"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
