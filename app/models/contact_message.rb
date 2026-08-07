class ContactMessage < ApplicationRecord
  validates :name, :email, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :ordered, -> { order(created_at: :desc) }
  scope :unviewed, -> { where(viewed: false) }
end
