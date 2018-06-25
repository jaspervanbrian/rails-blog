class Post < ApplicationRecord
  belongs_to :user

  has_many :comments

  scope :latest, lambda { order(created_at: :desc) }

  # Pagination kaminari
  paginates_per 10
end
