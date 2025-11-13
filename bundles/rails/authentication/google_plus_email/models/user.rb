# frozen_string_literal: true

# User model with Email + Google OAuth authentication
#
# This model provides:
# - Email/password authentication with BCrypt
# - Google OAuth (Sign in with Google)
# - JWT token management
# - Password reset functionality
# - User status management
# - API key generation
#
# Usage:
#   user = User.authenticate('email@example.com', 'password')
#   user = User.from_gsi(google_payload)
#   user.update_session  # Generates JWT token
class User < ApplicationRecord
  attr_accessor :password, :password_confirmation,
                :new_password, :new_password_confirmation

  # Validations
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email

  validates_uniqueness_of :email,
                          on: [:create, :update],
                          allow_blank: true

  validates_format_of :email,
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates_presence_of :password,
                        on: :create

  validates_confirmation_of :password,
                            on: :create

  validates_confirmation_of :password,
                            on: :update,
                            if: ->(user) { user.password.present? }

  validates_length_of :password,
                      on: :create,
                      minimum: 8

  validates_format_of :password,
                      on: :create,
                      with: /\A(?=.*[a-zA-Z]).{6,}\Z/,
                      message: 'is not secure enough.'

  # Callbacks
  before_validation :downcase_email
  before_validation :set_apikey, on: :create
  before_validation :set_status, on: :create
  before_create :encrypt_password
  before_update :encrypt_password

  # Constants
  USER_STATUSES = ['ACTIVE', 'INACTIVE', 'PENDING', 'BANNED'].freeze

  # Scopes
  scope :for_status, ->(status) { where('status = ?', status) if status.present? }

  # Class methods
  class << self
    def statuses
      USER_STATUSES
    end

    ##
    # Email/Password Authentication
    #
    # Example:
    #   user = User.authenticate('email@example.com', 'password')
    def authenticate(email, password)
      user = find_by_email(email)
      if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
        user
      end
    end

    ##
    # Google OAuth Authentication
    #
    # Example:
    #   payload = Google::Auth::IDTokens.verify_oidc(credential, aud: google_client_id)
    #   user = User.from_gsi(payload)
    def from_gsi(payload)
      user = find_by_email(payload['email'])

      unless user
        password = SecureRandom.hex(15)
        user = new(
          email: payload['email'],
          first_name: payload['given_name'],
          last_name: payload['family_name'],
          provider: 'Google',
          oauth_sub: payload['sub'],
          password: password,
          password_confirmation: password
        )

        user.save
      end

      user
    end
  end

  # Instance methods

  ##
  # Returns full name
  #
  # Example:
  #   user.name #=> "John Doe"
  def name
    "#{first_name} #{last_name}"
  end

  ##
  # Generate password reset token
  def generate_reset_token
    self.password_reset_key = "#{Time.now.to_i}-#{SecureRandom.uuid}"
  end

  ##
  # Update and save password reset token
  def update_reset_token
    generate_reset_token
    save
  end

  ##
  # Update session with new JWT token
  #
  # Example:
  #   user.update_session
  def update_session
    update!(
      jwt: JsonWebToken.jwt_encode(self),
      signed_in: true
    )
  end

  private

  ##
  # Downcase email before validation
  def downcase_email
    self.email = email.downcase if email.present?
  end

  ##
  # Encrypt password with BCrypt
  def encrypt_password
    if password.present? && !new_password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    elsif new_password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(new_password, password_salt)
    end
  end

  ##
  # Generate unique API key for user
  def set_apikey
    model = self.class.name.capitalize.constantize
    self.apikey = SecureRandom.urlsafe_base64 while model.exists?(apikey: apikey)
  end

  ##
  # Set default status to ACTIVE
  def set_status
    self.status = 'ACTIVE'
  end
end
