class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session


  def error_response(msg:, status_code:)
    render json:  {error: msg }, status: status_code
  end


  private

  def set_current_user
    bearer_token = request.headers['Authorization']
    bearer_token = bearer_token.split('Bearer ').last&.strip if bearer_token
    begin
      decoded = JsonWebToken.jwt_decode(bearer_token)
      user = User.find_by(apikey: decoded['user_key'], status: "ACTIVE")
      return error_response(msg: "User not found.", status_code: 404) if user.nil?

      valid = JsonWebToken.validate(decoded, user)
      unless valid && user&.signed_in
        return error_response(msg: "Session expired. Please login.", status_code: 401)
      end
      @current_user = user
    rescue
      nil
    end
  end


  def current_user
    @current_user
  end


  def authenticate_request
    begin
      @current_user = set_current_user
      return error_response(msg: "unauthorized", status_code: 401) if @current_user.nil?
    rescue
      return error_response(msg: "unauthorized", status_code: 401)
    end
  end

end
