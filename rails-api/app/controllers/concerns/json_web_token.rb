require 'jwt'

module JsonWebToken
  extend ActiveSupport::Concern

  class << self
    include Rails.application.routes.url_helpers
  end

  def self.jwt_encode(user, exp = 5.days.from_now)
    payload = {
      user_key: user.apikey,
      first_name: user.first_name,
      last_name: user.last_name,
      name: user.name,
      email: user.email
    }


    payload[:expires_at] = exp.to_i
    JWT.encode(payload, Figaro.env.lockbox_key)
  end

  def self.jwt_decode(token)
    decoded = JWT.decode(token, Figaro.env.lockbox_key)[0]
    HashWithIndifferentAccess.new decoded
  end

  def self.validate(payload, user)
    return false if user == nil
    if (expires_at = payload.dig('expires_at')).present?
      expires_at = Time.at(expires_at).to_date
      expires_at >= Time.now
    else
      # if the expires_at has past then update signed_in to false so they have to login again.
      user.update(signed_in: false) rescue nil
      false
    end
  end
end
