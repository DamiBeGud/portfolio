class TimelineEntry < ApplicationRecord
  include Sortable

  CATEGORIES = %w[experience education].freeze
  MONTHS = Date::MONTHNAMES.each_with_index.filter_map { |name, index| [name, index] if name }.freeze

  before_validation :append_to_category, on: :create

  validates :category, :meta, :title, :description, presence: true
  validates :category, inclusion: { in: CATEGORIES }
  validates :start_month, :end_month, inclusion: { in: 1..12 }, allow_blank: true
  validates :start_year, :end_year, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: 2200 }, allow_blank: true

  scope :ordered, -> { order(:sort_order, :created_at) }
  scope :experience, -> { where(category: "experience").ordered }
  scope :education, -> { where(category: "education").ordered }

  def timeframe
    return "" unless start_year.present? || end_year.present? || current?

    [formatted_start_date, formatted_end_date].compact.join(" - ")
  end

  def meta_with_timeframe
    [meta, timeframe.presence].compact.join(" / ")
  end

  private

  def formatted_start_date
    formatted_date(start_month, start_year)
  end

  def formatted_end_date
    return "Present" if current?

    formatted_date(end_month, end_year)
  end

  def formatted_date(month, year)
    return if year.blank?

    [Date::MONTHNAMES[month.to_i], year].compact.join(" ")
  end

  def append_to_category
    return if sort_order.positive?

    self.sort_order = self.class.where(category: category).maximum(:sort_order).to_i + 1
  end

  def sortable_records
    self.class.where(category: category).ordered
  end
end
