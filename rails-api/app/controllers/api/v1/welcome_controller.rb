class Api::V1::WelcomeController < ApplicationController
  before_action :current_user, only: [:signout]
  before_action :authenticate_request, only: [:signout]


  # GET: /
  def index
    # Just because something doesn't do what you planned it to do doesn't mean it's useless.
    return error_response(msg: "SnVzdCBiZWNhdXNlIHNvbWV0aGluZyBkb2VzbuKAmXQgZG8gd2hhdCB5b3UgcGxhbm5lZCBpdCB0byBkbyBkb2VzbuKAmXQgbWVhbiBpdOKAmXMgdXNlbGVzcy4=", status_code: 200)
  end


  # POST: /v1/signin
  def signin
    @user = User.authenticate(params[:data][:email], params[:data][:password])

    if @user
      @user.update_session
    else
      return error_response(msg: 'Invalid email or password', status_code: 422)
    end
  end


  # POST: /v1/signup
  def signup
    @user = User.new(user_params)
    @user.provider = 'Internal'

    if @user.save
      @user.update_session
    else
      return error_response(msg: @user.errors.full_messages, status_code: 422)
    end
  end


  # POST: /v1/signout
  def signout
    if current_user.update(signed_in: false, jwt: nil)
      render json: { message: 'Signed out' }, status: :ok
    else
      return error_response(msg: "Could not sign out user", status_code: 422)
    end
  end


  # POST: /v1/forgot_password
  def forgot_password
    user = User.find_by_email(params[:forgot_password][:email])
    if user && user.provider == "Internal"
      code = set_passcode
      user.update(password_reset_key: SecureRandom.uuid,
                  password_reset_expires: 10.minutes.from_now,
                  password_reset_code: code ); #make a reset token, code, and expiration
      UserMailer.with(user: user,
                      link: params[:forgot_password][:link],
                      code: user.password_reset_code,
                      token: user.password_reset_key).forgot_password.deliver_now
      render json: { success: "Email has been sent." }, status: :ok
    else
      return error_response(msg: 'User is not found or, password is not managed here.', status_code: 404)
    end
  end


  # POST: /v1/reset_password
  def reset_password
    return error_response(msg: 'A reset token is required.', status_code: 406) if params[:password_reset][:token].nil?
    return error_response(msg: 'A code is required.', status_code: 406) if params[:password_reset][:code].nil?
    return error_response(msg: 'A password is required.', status_code: 406) if params[:password_reset][:password].nil?
    return error_response(msg: 'A password confirmation is required.', status_code: 406) if params[:password_reset][:password_confirmation].nil?
    @user = User.find_by(password_reset_key: params[:password_reset][:token])

    # User exists and has the correct code
    if @user && @user.password_reset_code == params[:password_reset][:code]
      # User clicked the link within required timeframe
      if @user.password_reset_expires > 30.minutes.ago
        # Allow password change
        if @user.update(new_password: params[:password_reset][:password], new_password_confirmation: params[:password_reset][:password_confirmation])
          @user.update(password_reset_key: nil,
                       password_reset_expires: nil,
                       password_reset_code: nil)
          # Return a new JWT
          render json: { jwt: JsonWebToken.jwt_encode(@user) }, status: :ok
        else
          return error_response(msg: @user.errors.full_messages, status_code: 400)
        end
      else
        return error_response(msg: 'Link expired.', status_code: 401)
      end
    else
      return error_response(msg: 'Unable to confirm user.', status_code: 401)
    end
  end


  def set_passcode
    code = ""
    4.times do
      char = ['2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','J','K','M','N','P','Q','R','S','T','U','V','W','X','Y','Z'].sample
      code = code + char
    end
    if code.present? && code.size == 4
      return code
    end
  end


  # Google Sign In Callback
  # Post /api/v1/auth/gsi/callback
  def gsi
    begin
      #payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: Figaro.env.google_client_id)
      @user = User.from_gsi(params[:data]) # find_or_create user with payload
      if @user.present?
        @user.update_session
        render :signin
      else
        return error_response(msg: "There was a problem with your authentication", status_code: 400)
      end
    rescue Google::Auth::IDTokens::SignatureError, Google::Auth::IDTokens::AudienceMismatchError
      #The JWT could not be validated. Redirect or raise an exception here.
      return error_response(msg: "There was a problem with your authentication", status_code: 400)
    end
  end

  # POST
  def apple_auth
    begin
      user = User.from_apple(params[:payload])
      if user.present?
        user.update_session
        #send user token back to client
        token = JsonWebToken.jwt_encode(user)
        render json: UsersSerializer.render(user.reload, view: :extended), status: :ok
      else
        return error_response(msg: "There was a problem with your authentication", status_code: 400)
      end
    rescue StandardError => e
      return error_response(msg: "There was a problem with Apple authentication", status_code: 400)
    end
  end


  # POST
  def fb_auth
    begin
      user = User.from_fb(params[:id], params[:name])
      if user.present?
        user.update_session
        token = JsonWebToken.jwt_encode(user)
        render json: UsersSerializer.render(user.reload, view: :extended), status: :ok
      else
        return error_response(msg: "There was a problem with your authentication", status_code: 400)
      end
    rescue StandardError => e
      return error_response(msg: "There was a problem with your Facebook authentication", status_code: 400)
    end
  end


  def validate_token
    token = params[:token]
    if token.nil?
      return error_response(msg: "token must be present", status_code: 400)
    end
    decoded = JsonWebToken.jwt_decode(token)
    user = User.find_by(id: decoded['user_id'])
    valid = JsonWebToken.validate(decoded, user)
    render json: {valid: valid}
  end


  # GET
  def get_user
    @user = User.find_by_apikey(params[:user_apikey])
    if @user
      # TODO: Use jbuilder to return the correct response
      #response = {user: user}
    else
      response = {error: "Unable to authenticate"}
    end
    #render json: response
  end


  # GET
  def verified
    user = User.find_by_apikey(params[:apikey])
    if user
      if user.tos && user.tos == true
        response = true
      else
        response = false
      end
    else
      response = false
    end
    render json: { tos: response }
  end


  # POST
  def verified_do
    user = User.find_by_apikey(params[:apikey])
    if user && params[:tos]
      if user.update(tos: true)
        response = true
      else
        response = false
      end
    else
      response = false
    end
    render json: { tos: response }
  end





  private

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :dob,
        :city,
        :state,
        :password,
        :password_confirmation
      )
    end


end
