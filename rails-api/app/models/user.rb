class User < ApplicationRecord
  attr_accessor   :password, :password_confirmation,
                  :new_password, :new_password_confirmation

  has_one_attached :profile_photo


  validates_presence_of          :first_name

  validates_presence_of          :last_name

  validates_presence_of          :email

  validates_uniqueness_of        :email,
                                 on: [:create, :update],
                                 :allow_blank => true # when updating and not setting this

  validates_format_of            :email,
                                 :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i


  validates_presence_of          :password,
                                 :on => :create

  validates_confirmation_of      :password,
                                 :on => :create

  validates_confirmation_of      :password,
                                 :on => :update, :if => lambda {|password| password.present?}

  validates_length_of            :password,
                                 :on => :create,
                                 :minimum => 8

  validates_format_of            :password,
                                 :on => :create,
                                 :with => /\A(?=.*[a-zA-Z]).{6,}\Z/,
                                 :message => "is not secure enough."

  before_validation              :downcase_email

  before_validation              :set_apikey,
                                 :on => :create

  before_validation              :set_status,
                                 :on => :create

  before_create                  :encrypt_password
  before_update                  :encrypt_password


  USER_STATUSES = ['ACTIVE', 'INACTIVE', 'PENDING', 'BANNED']

  def self.statuses
    self::USER_STATUSES
  end

  ##
  #Status types for User: (notice the status is in all caps)
  #
  #PENDING = USER not validated
  #
  #ACTIVE = USER is available for sending and receiving (*default)
  #
  #INACTIVE = USER is not available for sending or receiving
  #
  #BANNED = USER is not able to be removed, or login
  #
  #EX: user = User.for_status('ACTIVE')
  scope :for_status, ->(status) { where("status = ?", status) if status.present? }


  ##
  #A convenience method to show a full name
  #
  #Example:
  #
  # user.name
  def name
    return "#{self.first_name} #{self.last_name}"
  end


  ##
  #If email is new or being updated, let's make sure it's downcased first
  def downcase_email
    self.email = email.downcase if email.present?
  end


  def update_session
    update!(
      jwt: JsonWebToken.jwt_encode(self),
      signed_in: true
    )
  end


  # Email/Password Auth
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      return user
    else
      return nil
    end#if user
  end


  # Google Auth
  def self.from_gsi(payload)
    user = User.find_by_email(payload[:email])
    if !user
      password = SecureRandom.hex(15)
      user = User.new(email: payload["email"],
                      first_name: payload[:given_name],
                      last_name: payload[:family_name],
                      provider: 'Google',
                      oauth_sub: payload[:sub],
                      password: password,
                      password_confirmation: password)

      if !user.save
        user = nil
      end
      return user
    else
      return user
    end
  end


  # Apple Auth
  def self.from_apple(payload)
    id_token = payload["authorization"]["id_token"]
    token_data = apple_cert(id_token)
    if token_data["email"]
      email = token_data['email']
      user = User.find_by_email(email)
      if !user
        password = SecureRandom.hex(15)
        user = User.new(email: email,
                        first_name: payload['user']['name']['firstName'],
                        last_name: payload['user']['name']['lastName'],
                        provider: 'Apple',
                        oauth_sub: token_data['sub'],
                        password: password,
                        password_confirmation: password)
        if !user.save
          user = nil
        end
      end

      return user

    else
      return nil
    end
  end



  # Facebook Auth
  def self.from_fb(id, name)
    email = "#{id}@fb.meta" #make up an email
    user = User.find_by_email(email)
    if !user
      name = name.split(" ")
      handle = "#{name.first}-#{id.last(6)}"
        password = SecureRandom.hex(15)
        user = User.new(email: email,
                        first_name: name.first,
                        last_name: name.last,
                        handle: handle,
                        provider: 'Facebook',
                        oauth_sub: nil,
                        password: password,
                        password_confirmation: password)
        if !user.save
          user = nil
        end
    end

    return user
  end


  private


  #TODO: NEED TO WRITE TEST
  def encrypt_password
    if password.present? && !new_password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    elsif new_password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(new_password, password_salt)
    end
  end



  def set_apikey
    model = self.class.name.capitalize.constantize
    begin
      self.apikey = SecureRandom.urlsafe_base64
    end while model.exists?(apikey: self.apikey)
  end


  def set_status
    self.status = "ACTIVE"
  end

end
