class User < ApplicationRecord
  before_create :generate_auth_token!
  has_secure_password
  validates :password, presence: true, length: {minimum: 8}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    format: {with: VALID_EMAIL_REGEX},
                    length: {maximum: 255},
                    uniqueness: {case_sensitive: false}
  validates :auth_token, uniqueness: true

    def User.new_token
      SecureRandom.urlsafe_base64
    end

  def generate_auth_token!
    auth_token = User.new_token
    begin
      self.auth_token = auth_token
    end while self.class.exists?(auth_token: auth_token)
  end
end