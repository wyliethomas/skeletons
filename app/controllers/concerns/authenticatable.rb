# frozen_string_literal: true

# Authenticatable concern for ApplicationController
#
# Provides session-based authentication with automatic expiry and refresh
#
# Usage in ApplicationController:
#   class ApplicationController < ActionController::Base
#     include Authenticatable
#     before_action :authenticate_user  # Add to controllers that require auth
#   end
module Authenticatable
  extend ActiveSupport::Concern

  # Session timeout duration (in minutes)
  SESSION_TIMEOUT = 30.minutes

  included do
    helper_method :current_user
  end

  ##
  # Get current user from session
  #
  # Usage:
  #   current_user
  #   @current_user_token
  #   @current_user_initials
  def current_user
    return nil unless session[:user_id]

    @current_user ||= User.find_by(apikey: session[:user_id])

    # Set helper variables
    if @current_user
      @current_user_token = session[:jwt]
      @current_user_name = @current_user.name
      @current_user_initials = "#{@current_user.first_name.first}#{@current_user.last_name.first}"
    end

    @current_user
  end

  ##
  # Authenticate user with configurable session expiry
  #
  # Automatically refreshes session on each request if still valid.
  # Redirects to signin if session expired or missing.
  #
  # Usage:
  #   before_action :authenticate_user
  def authenticate_user
    if session[:user_id] && session[:expiry_time]
      if session[:expiry_time] >= SESSION_TIMEOUT.ago.to_s
        # Session is still valid - refresh expiry time
        session[:expiry_time] = Time.current.to_s
        # USER MAY PASS (current_user will be fetched on demand)
      else
        # Session expired
        clear_session
        redirect_to signin_path
      end
    else
      # No session found
      redirect_to signin_path
    end
  end

  ##
  # Clear all session data
  def clear_session
    session[:user_id] = nil
    session[:user_name] = nil
    session[:user_email] = nil
    session[:jwt] = nil
    session[:expiry_time] = nil
    session[:last_page] = nil
  end

  ##
  # Create user session after successful authentication
  #
  # Usage:
  #   create_user_session(user)
  def create_user_session(user)
    session[:user_id] = user.apikey
    session[:expiry_time] = Time.current.to_s
  end
end
