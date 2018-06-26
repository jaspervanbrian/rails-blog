class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :posts
  has_many :comments

  before_save { self.email = email.downcase }
  validates :name, presence: true
  validates :password, length: { minimum: 8 }, presence: true
  validates :email, presence: true, 'valid_email_2/email': true

  has_secure_password
  # attr_reader :password
  # validates_presence_of :password, on: :create
  # validates_confirmation_of :password

  class << self
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
end
