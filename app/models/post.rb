class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy

  scope :latest, lambda { order(created_at: :desc) }

  # Pagination kaminari
  paginates_per 10

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

end
