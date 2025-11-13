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

  ##
  # Get current user from session
  #
  # Usage:
  #   current_user
  #   @current_user_token
  #   @current_user_initials
  def current_user
    @current_user_token = session[:jwt]
    @current_user_name = session[:user_name]

    if session[:current_user]
      first_name = session[:current_user]['first_name'].first
      last_name = session[:current_user]['last_name'].first
      @current_user_initials = "#{first_name}#{last_name}"
    end

    @current_user
  end

  ##
  # Authenticate user with 30-minute session expiry
  #
  # Automatically refreshes session on each request if still valid.
  # Redirects to signin if session expired or missing.
  #
  # Usage:
  #   before_action :authenticate_user
  def authenticate_user
    if session[:current_user] && session[:expiry_time]
      if session[:expiry_time] >= 30.minutes.ago.to_s
        # Session is still valid - refresh expiry time
        session[:expiry_time] = Time.current.to_s
        @current_user = session[:current_user]
        # USER MAY PASS
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
    session[:current_user] = nil
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
    session[:current_user] = user
    session[:user_id] = user.apikey
    session[:expiry_time] = Time.current.to_s
  end
end
