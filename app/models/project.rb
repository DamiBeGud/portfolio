class Project < ApplicationRecord
  include Sortable

  PREVIEW_STYLES = %w[default inverse grid].freeze

  has_one_attached :image

  validates :title, :description, presence: true
  validates :preview_style, inclusion: { in: PREVIEW_STYLES }

  scope :ordered, -> { order(:sort_order, :created_at) }

  def technology_list
    technologies.to_s.split(",").map(&:strip).reject(&:blank?)
  end
end
