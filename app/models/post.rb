class Post < ApplicationRecord
  belongs_to :user

  has_many :comments

  scope :latest, lambda { order(created_at: :desc) }

  # Pagination kaminari
  paginates_per 10

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  before_destroy :remove_comments

  private

  def remove_comments
    self.comments.destroy_all
  end
end
