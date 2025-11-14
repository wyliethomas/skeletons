# frozen_string_literal: true

module Api
  module V1
    class WelcomeController < BaseController
      # GET /api/v1
      def index
        render json: {
          message: 'Welcome to your Rails API',
          version: '1.0.0',
          status: 'running',
          endpoints: {
            health: '/health',
            api_root: '/api/v1'
          }
        }, status: :ok
      end
    end
  end
end
