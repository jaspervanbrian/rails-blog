class User < ApplicationRecord
  has_many :posts
  has_many :comments

  validates :name, presence: true
  validates :username, length: { in: 4..30 }, presence: true
  validates :password_digest, length: { minimum: 8 }, presence: true
  validates :email, presence: true

  has_secure_password
  # attr_reader :password
  # validates_presence_of :password, on: :create
  # validates_confirmation_of :password

end
