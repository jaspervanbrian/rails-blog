class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many_attached :images, dependent: :destroy

  validates :body, presence: true
  validate :images_type

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
