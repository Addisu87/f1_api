Rails.application.routes.draw do
  # API Documentation
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  # Root redirects to API documentation
  root to: redirect("/api-docs")

  # Devise routes for API
  devise_for :users,
    path: "api/v1/auth",
    skip: :all

  namespace :api do
    namespace :v1 do
      # Custom authentication routes
      devise_scope :user do
        post "auth/register", to: "users/registrations#create", as: :user_registration
        post "auth/login", to: "users/sessions#create", as: :user_session
        delete "auth/logout", to: "users/sessions#destroy"
      end

      resources :drivers do
        resources :lap_times, only: [ :index ], controller: "lap_times"
      end
      resources :circuits do
        resources :lap_times, only: [ :index ], controller: "lap_times"
      end
      resources :lap_times do
        collection do
          get :fastest
        end
      end

      get "standings", to: "standings#index"
      get "health", to: "health#index"
    end
  end

  # Admin dashboard
  # get "admin", to: "admin/dashboard#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "home#index"
end
