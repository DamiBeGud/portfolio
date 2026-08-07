class RenameRoleToHeroKickerOnSiteSettings < ActiveRecord::Migration[8.1]
  def change
    rename_column :site_settings, :role, :hero_kicker
  end
end
