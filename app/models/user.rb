class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :posts
  has_many :comments

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :password, length: { minimum: 8, maximum: 255 }, presence: true
  validates :email, presence: true, 'valid_email_2/email': true, length: { maximum: 255 }

  before_save { self.email = email.downcase }
  before_save { self.first_name = first_name.capitalize }
  before_save { self.last_name = last_name.capitalize }

  before_destroy :remove_comments
  before_destroy :remove_posts

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

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil? # Here, we check if remember_digest is nil. Happens when cookie was deleted from other browser.
    BCrypt::Password.new(remember_digest).is_password?(remember_token) # Will raise an exception if remember_digest is nil.
  end

  # Forget user
  def forget
    update_attribute(:remember_digest, nil)
  end

  def full_name
    return self.first_name + " " + self.last_name
  end

  private

  def remove_comments
    self.comments.destroy_all
  end

  def remove_posts
    self.posts.destroy_all
  end
end
