class AddVisitorControlsToSiteSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :site_settings, :show_animation_toggle, :boolean, null: false, default: true
    add_column :site_settings, :show_theme_toggle, :boolean, null: false, default: true
  end
end
