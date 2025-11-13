# frozen_string_literal: true

# Authentication Controller
#
# Handles:
# - Email/password sign in and sign up
# - Google OAuth (Sign in with Google)
# - Password reset
# - Sign out
#
# Routes needed:
#   get  '/signin',  to: 'auth#signin',  as: :signin
#   post '/signin',  to: 'auth#signin_do'
#   get  '/signup',  to: 'auth#signup',  as: :signup
#   post '/signup',  to: 'auth#signup_do'
#   get  '/signout', to: 'auth#signout', as: :signout
#   post '/gsi',     to: 'auth#gsi'
#   get  '/gsi/session', to: 'auth#gsi_session', as: :gsi_session
#   get  '/forgot',  to: 'auth#forgot',  as: :forgot
#   post '/forgot',  to: 'auth#forgot_do'
#   get  '/reset-password/:reset_token', to: 'auth#reset_password', as: :reset_password
#   post '/reset-password', to: 'auth#reset_password_do'
class AuthController < ApplicationController
  layout 'auth'

  ##
  # GET /signin
  def signin
    # Renders signin form
  end

  ##
  # POST /signin
  # Authenticate user with email/password
  def signin_do
    user = User.authenticate(params[:email], params[:password])

    if user
      create_user_session(user)

      # Redirect to last page or dashboard
      path = session[:last_page] || dashboard_root_path
      session[:last_page] = nil

      redirect_to path
    else
      flash[:alert] = 'Incorrect username or password. Please try again.'
      redirect_to signin_path
    end
  end

  ##
  # GET /signup
  def signup
    # Renders signup form
  end

  ##
  # POST /signup
  # Create new user account
  def signup_do
    user = User.new(user_params)

    if user.save
      create_user_session(user)

      # Handle any pending invites
      check_invites(user) if defined?(check_invites)

      # Redirect based on signin_redirect or default to dashboard
      path = session[:signin_redirect] || dashboard_root_path
      session[:signin_redirect] = nil

      redirect_to path
    else
      flash[:error] = user.errors.full_messages
      redirect_to signup_path
    end
  end

  ##
  # GET /signout
  def signout
    flash[:notice] = 'Bye. Come back soon.'
    clear_session
    redirect_to signin_path
  end

  ##
  # POST /gsi
  # Google OAuth callback
  #
  # Expects params[:credential] with Google ID token
  # Returns JSON with user apikey or error
  def gsi
    payload = Google::Auth::IDTokens.verify_oidc(
      params[:credential],
      aud: ENV['GOOGLE_CLIENT_ID']
    )

    user = User.from_gsi(payload)

    if user
      render json: { apikey: user.apikey }, status: :ok
    else
      render json: { error: 'There was a problem with your authentication' }, status: :bad_request
    end
  end

  ##
  # GET /gsi/session
  # Create session after successful Google authentication
  #
  # Expects params[:user_apikey]
  def gsi_session
    user = User.find_by_apikey(params[:user_apikey])

    if user
      create_user_session(user)

      # Redirect to last page or dashboard
      path = session[:last_page] || dashboard_root_path
      session[:last_page] = nil

      redirect_to path
    else
      flash[:error] = 'There was a problem with your authentication.'
      redirect_to signin_path
    end
  end

  ##
  # GET /forgot
  def forgot
    # Renders password reset request form
  end

  ##
  # POST /forgot
  # Send password reset email
  def forgot_do
    user = User.find_by_email(params[:email])

    if user
      user.update_reset_token

      # Send password reset email
      # ContactMailer.reset_password(user: user).deliver_now

      flash[:success] = 'Check your email for instructions on how to change your password.'
    else
      flash[:alert] = 'Email provided not found.'
    end

    redirect_to signin_path
  end

  ##
  # GET /reset-password/:reset_token
  def reset_password
    user = User.find_by_password_reset_key(params[:reset_token])

    unless user
      flash[:notice] = 'There was a problem reading your link'
      redirect_to signin_path
    end

    # Renders password reset form
  end

  ##
  # POST /reset-password
  # Update password with reset token
  def reset_password_do
    if params[:password] == params[:password_confirmation]
      user = User.find_by_password_reset_key(params[:reset_token])

      if user
        user.update_reset_token  # Invalidate old token
        user.update(
          password: params[:password],
          password_confirmation: params[:password_confirmation],
          status: 'ACTIVE'
        )

        flash[:notice] = 'Your password has been changed. You may login now.'
        redirect_to signin_path
      else
        flash[:error] = 'Not able to change password.'
        redirect_to signin_path
      end
    else
      flash[:error] = 'Password and confirmation do not match.'
      redirect_to reset_password_path(reset_token: params[:reset_token])
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
