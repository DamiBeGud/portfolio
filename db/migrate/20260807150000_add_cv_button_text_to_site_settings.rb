class AddCvButtonTextToSiteSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :site_settings, :cv_button_text, :string, default: "Download CV", null: false
  end
end
