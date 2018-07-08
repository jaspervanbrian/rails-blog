class Post < ApplicationRecord
  belongs_to :user

  attr_reader :first_attachment

  has_many :comments, dependent: :destroy
  has_many_attached :attachments, dependent: :destroy

  scope :latest, lambda { order(created_at: :desc) }

  # Pagination kaminari
  paginates_per 10

  validates :title, presence: true, length: { maximum: 255 }
  validate :content
  validate :attachments_type

  def first_attachment
    self.attachments.first if self.attachments.present?
  end

  private

  def content
    if self.body.blank? && self.attachments.blank?
      errors[:body] << "Post must have content."
      errors[:attachments] << "Post must have content."
    end
  end

  def attachments_type
    if attachments.attached?
      attachments.each do |attachment|
        content_type = attachment.blob.content_type
        if attachment.blob.byte_size > 5000000
          attachment.purge
          errors[:attachments] << "Too big."
        elsif !content_type.starts_with?("image/") && !content_type.starts_with?("video/")
          attachment.purge
          errors[:attachments] << "Invalid photo/video format."
        end
      end
    end
  end

end
