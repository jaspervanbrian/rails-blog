class Post < ApplicationRecord
  belongs_to :user

  attr_reader :first_image

  has_many :comments, dependent: :destroy
  has_many_attached :images, dependent: :destroy

  scope :latest, lambda { order(created_at: :desc) }

  # Pagination kaminari
  paginates_per 10

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true
  validate :images_type

  def first_image
    self.images.first if self.images.present?
  end

  private

  def images_type
    if images.attached?
      images.each do |image|
        if image.blob.byte_size > 5000000
          image.purge
          errors[:images] << "Too big."
        elsif !image.blob.content_type.starts_with?("image/")
          image.purge
          errors[:images] << "Invalid photo format."
        end
      end
    end
  end

end
