class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :latest, lambda { order(created_at: :desc) }

end
