class User < ApplicationRecord
  attr_accessor :activation_token
  before_create :downcase_email!
  before_create :generate_activation_digest!
  before_create :generate_auth_token!
  has_secure_password
  validates :password, presence: true, length: {minimum: 8}, allow_nil: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    format: {with: VALID_EMAIL_REGEX},
                    length: {maximum: 255},
                    uniqueness: {case_sensitive: false}
  validates :auth_token, uniqueness: true

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                          BCrypt::Engine.cost
  BCrypt::Password.create(string, cost: cost)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def generate_activation_digest!
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def generate_auth_token!
    auth_token = User.new_token
    begin
      self.auth_token = auth_token
    end while self.class.exists?(auth_token: auth_token)
  end

  def downcase_email!
    self.email.downcase!
  end
end