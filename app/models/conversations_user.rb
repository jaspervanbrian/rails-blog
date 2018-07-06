class ConversationsUser < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
end
