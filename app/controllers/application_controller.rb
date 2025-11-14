class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def error_response(msg:, status_code:)
    render json: { error: msg }, status: status_code
  end
end
