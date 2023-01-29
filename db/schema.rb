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

ActiveRecord::Schema[7.0].define(version: 2023_01_29_112152) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.uuid "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "available_goods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "consumption", default: "0.0", null: false
    t.decimal "production", default: "0.0", null: false
    t.uuid "island_id", null: false
    t.uuid "good_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "local_usage", default: "0.0", null: false
    t.decimal "export", default: "0.0", null: false
    t.decimal "import", default: "0.0", null: false
    t.index ["good_id"], name: "index_available_goods_on_good_id"
    t.index ["island_id"], name: "index_available_goods_on_island_id"
  end

  create_table "exports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "quantity"
    t.uuid "local_produced_good_id", null: false
    t.uuid "island_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["island_id"], name: "index_exports_on_island_id"
    t.index ["local_produced_good_id"], name: "index_exports_on_local_produced_good_id"
  end

  create_table "games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "input_goods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "input_good_id", null: false
    t.uuid "output_good_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["input_good_id"], name: "index_input_goods_on_input_good_id"
    t.index ["output_good_id"], name: "index_input_goods_on_output_good_id"
  end

  create_table "islands", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "game_id", null: false
    t.uuid "region_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_islands_on_game_id"
    t.index ["region_id"], name: "index_islands_on_region_id"
  end

  create_table "local_produced_goods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "production"
    t.decimal "consumption"
    t.uuid "island_id", null: false
    t.uuid "good_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["good_id"], name: "index_local_produced_goods_on_good_id"
    t.index ["island_id"], name: "index_local_produced_goods_on_island_id"
  end

  create_table "mobility_string_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.string "value"
    t.string "translatable_type"
    t.uuid "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_string_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_string_translations_on_keys", unique: true
    t.index ["translatable_type", "key", "value", "locale"], name: "index_mobility_string_translations_on_query_keys"
  end

  create_table "mobility_text_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.text "value"
    t.string "translatable_type"
    t.uuid "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "regions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "available_goods", "goods"
  add_foreign_key "available_goods", "islands"
  add_foreign_key "exports", "islands"
  add_foreign_key "exports", "local_produced_goods"
  add_foreign_key "input_goods", "goods", column: "input_good_id"
  add_foreign_key "input_goods", "local_produced_goods", column: "output_good_id"
  add_foreign_key "islands", "games"
  add_foreign_key "islands", "regions"
  add_foreign_key "local_produced_goods", "goods"
  add_foreign_key "local_produced_goods", "islands"
end
