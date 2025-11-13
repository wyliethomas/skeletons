# frozen_string_literal: true

require 'jwt'

# JsonWebToken module for encoding/decoding JWT tokens
#
# Provides methods to:
# - Encode user data into JWT
# - Decode JWT back to user data
# - Validate JWT expiry
#
# Usage:
#   token = JsonWebToken.jwt_encode(user)
#   payload = JsonWebToken.jwt_decode(token)
#   valid = JsonWebToken.validate(payload)
#
# Environment Variables Required:
#   JWT_SECRET_KEY - Secret key for signing JWTs
module JsonWebToken
  extend ActiveSupport::Concern

  class << self
    include Rails.application.routes.url_helpers
  end

  ##
  # Encode user data into JWT
  #
  # @param user [User] The user to encode
  # @param exp [Time] Expiration time (default: 5 days from now)
  # @return [String] JWT token
  #
  # Example:
  #   token = JsonWebToken.jwt_encode(user)
  #   token = JsonWebToken.jwt_encode(user, 24.hours.from_now)
  def self.jwt_encode(user, exp = 5.days.from_now)
    payload = {
      user_key: user.apikey,
      first_name: user.first_name,
      last_name: user.last_name,
      name: user.name,
      email: user.email,
      expires_at: exp.to_i
    }

    JWT.encode(payload, ENV['JWT_SECRET_KEY'])
  end

  ##
  # Decode JWT token
  #
  # @param token [String] JWT token to decode
  # @return [HashWithIndifferentAccess] Decoded payload
  #
  # Example:
  #   payload = JsonWebToken.jwt_decode(token)
  #   user_key = payload['user_key']
  def self.jwt_decode(token)
    decoded = JWT.decode(token, ENV['JWT_SECRET_KEY'])[0]
    HashWithIndifferentAccess.new decoded
  end

  ##
  # Validate JWT expiry
  #
  # @param payload [Hash] Decoded JWT payload
  # @return [Boolean] true if token is still valid, false if expired
  #
  # Example:
  #   if JsonWebToken.validate(payload)
  #     # Token is valid
  #   else
  #     # Token expired
  #   end
  def self.validate(payload)
    if (expires_at = payload.dig('expires_at')).present?
      expires_at = Time.at(expires_at).to_date
      expires_at >= Time.now
    else
      false
    end
  end
end
