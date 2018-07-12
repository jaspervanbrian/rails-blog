class Conversation < ApplicationRecord
	has_many :messages, dependent: :destroy
  has_many :conversations_users
	has_many :users, through: :conversations_users
  has_one_attached :logo, dependent: :destroy
end
