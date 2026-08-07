class CreatePortfolioContent < ActiveRecord::Migration[8.1]
  def change
    create_table :site_settings do |t|
      t.string :brand, null: false, default: "DB"
      t.string :page_title, null: false, default: "Software Developer Portfolio"
      t.text :meta_description, null: false, default: "Minimal software developer portfolio with editable content."
      t.string :role, null: false, default: "Software Developer"
      t.string :hero_title, null: false, default: "Hi. I am First Last Name"
      t.text :hero_intro, null: false
      t.text :hero_body, null: false
      t.string :about_kicker, null: false, default: "01 / About"
      t.string :about_title, null: false
      t.text :about_body, null: false
      t.string :projects_kicker, null: false, default: "02 / Projects"
      t.string :projects_title, null: false
      t.text :projects_body, null: false
      t.string :contact_kicker, null: false, default: "03 / Contact"
      t.string :contact_title, null: false
      t.string :contact_email, null: false, default: "developer@example.com"
      t.string :theme_mode, null: false, default: "system"
      t.string :light_background, null: false, default: "#f8f8f5"
      t.string :light_text, null: false, default: "#050505"
      t.string :light_surface, null: false, default: "#f8f8f5"
      t.string :light_muted, null: false, default: "#696963"
      t.string :light_border, null: false, default: "#050505"
      t.string :dark_background, null: false, default: "#050505"
      t.string :dark_text, null: false, default: "#f8f8f5"
      t.string :dark_surface, null: false, default: "#1c1c1a"
      t.string :dark_muted, null: false, default: "#a7a7a0"
      t.string :dark_border, null: false, default: "#f8f8f5"

      t.timestamps
    end

    create_table :timeline_entries do |t|
      t.string :category, null: false
      t.string :meta, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.integer :sort_order, null: false, default: 0

      t.timestamps
    end

    add_index :timeline_entries, [ :category, :sort_order ]

    create_table :info_cards do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.text :tags, null: false, default: ""
      t.integer :sort_order, null: false, default: 0

      t.timestamps
    end

    add_index :info_cards, :sort_order

    create_table :projects do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :technologies, null: false, default: ""
      t.string :live_url
      t.string :source_url
      t.string :preview_style, null: false, default: "default"
      t.integer :sort_order, null: false, default: 0

      t.timestamps
    end

    add_index :projects, :sort_order

    create_table :contact_links do |t|
      t.string :label, null: false
      t.string :url, null: false
      t.integer :sort_order, null: false, default: 0

      t.timestamps
    end

    add_index :contact_links, :sort_order
  end
end
