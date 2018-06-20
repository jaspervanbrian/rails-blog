class Post < ApplicationRecord
  belongs_to :user

  scope :latest, lambda { order(created_at: :desc) }
end
