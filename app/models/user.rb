class User < ApplicationRecord
  attr_accessor :remember_token

  has_one_attached :profile_avatar
  has_one_attached :profile_banner
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :password, length: { minimum: 8, maximum: 255 }, presence: true
  validates :email, presence: true, 'valid_email_2/email': true, length: { maximum: 255 }
  validate :photo_avatar_validation
  validate :photo_banner_validation

  before_save { self.email = email.downcase }
  before_save { self.first_name = first_name.capitalize }
  before_save { self.last_name = last_name.capitalize }

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

  def photo_avatar_validation
    if profile_avatar.attached?
      if profile_avatar.blob.byte_size > 1000000
        profile_avatar.purge
        errors[:profile_avatar] << 'Too big'
      elsif !profile_avatar.blob.content_type.starts_with?('image')
        profile_avatar.purge
        errors[:profile_avatar] << 'Wrong format'
      end
    end
  end

  def photo_banner_validation
    if profile_banner.attached?
      if profile_banner.blob.byte_size > 1000000
        profile_banner.purge
        errors[:profile_banner] << 'Too big'
      elsif !profile_banner.blob.content_type.starts_with?('image/')
        profile_banner.purge
        errors[:profile_banner] << 'Wrong format'
      end
    end
  end

end
