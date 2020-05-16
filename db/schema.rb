# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_11_194625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "buildings"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "locality_id", null: false
    t.bigint "location_type_id", null: false
    t.index ["locality_id"], name: "index_addresses_on_locality_id"
    t.index ["location_type_id"], name: "index_addresses_on_location_type_id"
  end

  create_table "courts", force: :cascade do |t|
    t.string "name"
    t.string "index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "subject_id", null: false
    t.index ["subject_id"], name: "index_courts_on_subject_id"
  end

  create_table "districts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "locality_id"
    t.index ["locality_id"], name: "index_districts_on_locality_id"
  end

  create_table "jurisdictions", force: :cascade do |t|
    t.integer "sector", null: false
    t.string "address"
    t.string "phone"
    t.jsonb "reception_of_citizens"
    t.jsonb "work_time"
    t.string "email"
    t.string "judge_fio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "district_id"
    t.string "site"
    t.string "index"
    t.index ["district_id"], name: "index_jurisdictions_on_district_id"
  end

  create_table "localities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "locality_type_id", null: false
    t.bigint "locality_id"
    t.bigint "district_id"
    t.index ["district_id"], name: "index_localities_on_district_id"
    t.index ["locality_id"], name: "index_localities_on_locality_id"
    t.index ["locality_type_id"], name: "index_localities_on_locality_type_id"
  end

  create_table "locality_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "location_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "types", id: false, force: :cascade do |t|
    t.string "name"
    t.string "index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "api_key"
  end

  add_foreign_key "addresses", "localities"
  add_foreign_key "addresses", "location_types"
  add_foreign_key "courts", "subjects"
  add_foreign_key "districts", "localities"
  add_foreign_key "jurisdictions", "districts"
  add_foreign_key "localities", "districts"
  add_foreign_key "localities", "localities"
  add_foreign_key "localities", "locality_types"
end
