class AddBackgroundPatternToSiteSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :site_settings, :background_pattern, :boolean, null: false, default: true
    add_column :site_settings, :light_grid_thickness, :integer, null: false, default: 1
    add_column :site_settings, :dark_grid_thickness, :integer, null: false, default: 1
  end
end
