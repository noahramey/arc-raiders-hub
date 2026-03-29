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

ActiveRecord::Schema[8.1].define(version: 2026_03_28_233103) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "arcs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "external_id", null: false
    t.jsonb "loot", default: []
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "synced_at"
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_arcs_on_external_id", unique: true
    t.index ["slug"], name: "index_arcs_on_slug", unique: true
  end

  create_table "event_schedules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.jsonb "schedule", default: {}
    t.datetime "synced_at"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_event_schedules_on_name", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.string "external_id", null: false
    t.string "image_url"
    t.string "item_type"
    t.jsonb "meta", default: {}
    t.string "name", null: false
    t.string "rarity"
    t.string "slug", null: false
    t.datetime "synced_at"
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_items_on_external_id", unique: true
    t.index ["slug"], name: "index_items_on_slug", unique: true
  end

  create_table "map_data", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "data", default: {}
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "synced_at"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_map_data_on_slug", unique: true
  end

  create_table "quests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "difficulty"
    t.string "external_id", null: false
    t.string "name", null: false
    t.jsonb "required_items", default: []
    t.jsonb "rewards", default: {}
    t.string "slug", null: false
    t.datetime "synced_at"
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_quests_on_external_id", unique: true
    t.index ["slug"], name: "index_quests_on_slug", unique: true
  end

  create_table "saved_builds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "items", default: []
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_saved_builds_on_user_id"
  end

  create_table "tracked_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "item_id", null: false
    t.integer "quantity_current", default: 0, null: false
    t.integer "quantity_needed", default: 1, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["item_id"], name: "index_tracked_items_on_item_id"
    t.index ["user_id"], name: "index_tracked_items_on_user_id"
  end

  create_table "traders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "external_id", null: false
    t.jsonb "inventory", default: []
    t.string "name", null: false
    t.datetime "synced_at"
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_traders_on_external_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "jti", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "saved_builds", "users"
  add_foreign_key "tracked_items", "items"
  add_foreign_key "tracked_items", "users"
end
