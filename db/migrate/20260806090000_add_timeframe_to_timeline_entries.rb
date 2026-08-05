class AddTimeframeToTimelineEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :timeline_entries, :start_month, :integer
    add_column :timeline_entries, :start_year, :integer
    add_column :timeline_entries, :end_month, :integer
    add_column :timeline_entries, :end_year, :integer
    add_column :timeline_entries, :current, :boolean, null: false, default: false
  end
end
