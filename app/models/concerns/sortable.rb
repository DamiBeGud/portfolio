module Sortable
  extend ActiveSupport::Concern

  def move_higher!
    move_by(-1)
  end

  def move_lower!
    move_by(1)
  end

  private

  def move_by(offset)
    records = sortable_records.to_a
    current_index = records.index { |record| record.id == id }
    target_index = current_index.to_i + offset

    return false unless current_index && target_index.between?(0, records.length - 1)

    records[current_index], records[target_index] = records[target_index], records[current_index]

    self.class.transaction do
      records.each.with_index(1) do |record, position|
        record.update!(sort_order: position)
      end
    end

    true
  end

  def sortable_records
    self.class.ordered
  end
end
