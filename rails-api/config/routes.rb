Rails.application.routes.draw do
  # Health check
  get "health", to: "health#show"

  # API routes
  namespace :api do
    namespace :v1 do
      # Welcome endpoint
      get '/', to: 'welcome#index'

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
