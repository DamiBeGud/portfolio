# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_07_140000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contact_links", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "label", null: false
    t.integer "sort_order", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["sort_order"], name: "index_contact_links_on_sort_order"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.text "message", null: false
    t.string "name", null: false
    t.boolean "responded", default: false, null: false
    t.datetime "updated_at", null: false
    t.boolean "viewed", default: false, null: false
    t.index ["created_at"], name: "index_contact_messages_on_created_at"
  end

  create_table "info_cards", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "sort_order", default: 0, null: false
    t.text "tags", default: "", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["sort_order"], name: "index_info_cards_on_sort_order"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "live_url"
    t.string "preview_style", default: "default", null: false
    t.integer "sort_order", default: 0, null: false
    t.string "source_url"
    t.text "technologies", default: "", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["sort_order"], name: "index_projects_on_sort_order"
  end

  create_table "site_settings", force: :cascade do |t|
    t.text "about_body", null: false
    t.string "about_kicker", default: "01 / About", null: false
    t.string "about_title", null: false
    t.boolean "background_pattern", default: true, null: false
    t.string "brand", default: "DB", null: false
    t.string "contact_email", default: "developer@example.com", null: false
    t.string "contact_kicker", default: "03 / Contact", null: false
    t.string "contact_title", null: false
    t.datetime "created_at", null: false
    t.string "dark_background", default: "#050505", null: false
    t.string "dark_border", default: "#f8f8f5", null: false
    t.integer "dark_grid_thickness", default: 1, null: false
    t.string "dark_muted", default: "#a7a7a0", null: false
    t.string "dark_surface", default: "#1c1c1a", null: false
    t.string "dark_text", default: "#f8f8f5", null: false
    t.text "hero_body", null: false
    t.text "hero_intro", null: false
    t.string "hero_kicker", default: "Software Developer", null: false
    t.string "hero_title", default: "Hi. I am Damjan Mlinaric", null: false
    t.string "light_background", default: "#f8f8f5", null: false
    t.string "light_border", default: "#050505", null: false
    t.integer "light_grid_thickness", default: 1, null: false
    t.string "light_muted", default: "#696963", null: false
    t.string "light_surface", default: "#f8f8f5", null: false
    t.string "light_text", default: "#050505", null: false
    t.text "meta_description", default: "Minimal software developer portfolio with editable content.", null: false
    t.string "page_title", default: "Software Developer Portfolio", null: false
    t.text "projects_body", null: false
    t.string "projects_kicker", default: "02 / Projects", null: false
    t.string "projects_title", null: false
    t.boolean "show_animation_toggle", default: true, null: false
    t.boolean "show_theme_toggle", default: true, null: false
    t.string "theme_mode", default: "system", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timeline_entries", force: :cascade do |t|
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.boolean "current", default: false, null: false
    t.text "description", null: false
    t.integer "end_month"
    t.integer "end_year"
    t.string "meta", null: false
    t.integer "sort_order", default: 0, null: false
    t.integer "start_month"
    t.integer "start_year"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["category", "sort_order"], name: "index_timeline_entries_on_category_and_sort_order"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
