class HealthController < ApplicationController
  skip_before_action :authenticate_request

  def show
    # Check database connectivity
    ActiveRecord::Base.connection.execute("SELECT 1")

    # Check Redis connectivity
    Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0")).ping

    render json: {
      status: "healthy",
      timestamp: Time.current,
      version: "1.0.0",
      environment: Rails.env
    }
  rescue => e
    render json: {
      status: "unhealthy",
      error: e.message,
      timestamp: Time.current
    }, status: :service_unavailable
  end
end
