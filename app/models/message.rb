class Message < ApplicationRecord
	belongs_to :conversation
	belongs_to :user
  has_many_attached :attachments, dependent: :destroy
end
