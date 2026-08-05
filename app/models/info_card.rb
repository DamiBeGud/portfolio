class InfoCard < ApplicationRecord
  validates :title, :body, presence: true

  scope :ordered, -> { order(:sort_order, :created_at) }

  def tag_list
    tags.to_s.split(",").map(&:strip).reject(&:blank?)
  end
end
