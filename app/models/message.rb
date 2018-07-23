class Message < ApplicationRecord
	belongs_to :conversation
	belongs_to :user
  has_many_attached :attachments, dependent: :destroy

  validate :content
  validate :attachments_type

  private

  def content
    if self.body.blank? && self.attachments.blank?
      errors[:body] << "Your message must have content."
      errors[:attachments] << "Your message must have content."
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
