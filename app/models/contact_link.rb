class ContactLink < ApplicationRecord
  validates :label, :url, presence: true

  scope :ordered, -> { order(:sort_order, :created_at) }
end
