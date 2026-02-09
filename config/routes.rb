Rails.application.routes.draw do
  # Health check
  get "health", to: "health#show"
  get "up", to: "health#show", as: :rails_health_check

  # Authentication routes
  # Email/Password Authentication
  get  '/signin',  to: 'auth#signin',  as: :signin
  post '/signin',  to: 'auth#signin_do'
  get  '/signup',  to: 'auth#signup',  as: :signup
  post '/signup',  to: 'auth#signup_do'
  get  '/signout', to: 'auth#signout', as: :signout

  # Google OAuth
  post '/gsi',         to: 'auth#gsi'
  get  '/gsi/session', to: 'auth#gsi_session', as: :gsi_session

  # Password Reset
  get  '/forgot',          to: 'auth#forgot',          as: :forgot
  post '/forgot',          to: 'auth#forgot_do'
  get  '/reset-password/:reset_token', to: 'auth#reset_password', as: :reset_password
  post '/reset-password',  to: 'auth#reset_password_do'

  # Account Management
  resource :account, only: [:edit, :update]

  # Client onboarding and management
  resource :client, only: [:new, :create, :show, :edit, :update]

  # Admin
  namespace :admin do
    root to: 'clients#index'

    resources :clients do
      collection do
        get :stats
      end
    end

    resources :users, only: [:index] do
      member do
        patch :toggle_status
      end
    end
  end

  # Root path - customize based on your needs
  root to: redirect('/signin')
end
