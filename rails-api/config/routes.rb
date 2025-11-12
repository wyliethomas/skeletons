Rails.application.routes.draw do
  # Health check
  get "health", to: "health#show"

  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication endpoints
      get '/', to: 'welcome#index'
      post 'signin', to: 'welcome#signin'
      post 'signup', to: 'welcome#signup'
      post 'signout', to: 'welcome#signout'
      post 'forgot_password', to: 'welcome#forgot_password'
      post 'reset_password', to: 'welcome#reset_password'
      post 'validate_token', to: 'welcome#validate_token'

      # OAuth endpoints
      post 'auth/gsi/callback', to: 'welcome#gsi'
      post 'auth/apple', to: 'welcome#apple_auth'
      post 'auth/facebook', to: 'welcome#fb_auth'

      # User management (authenticated)
      resources :users, only: [:index, :show, :create, :update, :destroy]

      # Add your API endpoints here
      # Example:
      # resources :posts
      # resources :comments
    end
  end

  # Sidekiq web UI (protect this in production!)
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
end
