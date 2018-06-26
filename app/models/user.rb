class User < ApplicationRecord
  has_many :posts
  has_many :comments

  validates :name, presence: true
  validates :password, length: { minimum: 8 }, presence: true
  validates :email, presence: true, 'valid_email_2/email': true

  has_secure_password
  # attr_reader :password
  # validates_presence_of :password, on: :create
  # validates_confirmation_of :password

end
