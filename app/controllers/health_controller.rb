class HealthController < ApplicationController
  skip_before_action :authenticate_user
  skip_before_action :require_client

  def show
    render json: { status: 'ok', timestamp: Time.current }, status: :ok
  end
end
