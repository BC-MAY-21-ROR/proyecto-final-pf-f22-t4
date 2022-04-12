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

ActiveRecord::Schema[7.0].define(version: 2022_04_12_145611) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "homes", force: :cascade do |t|
    t.string "title"
    t.string "address"
    t.string "description"
    t.decimal "price"
    t.decimal "score", precision: 4, scale: 2
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_homes_on_user_id"
  end

  create_table "pets", force: :cascade do |t|
    t.string "name"
    t.string "breed"
    t.string "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pets_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "guest_id", null: false
    t.bigint "host_id", null: false
    t.bigint "home_id", null: false
    t.datetime "check_in"
    t.datetime "check_out"
    t.integer "pets_number"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
    t.index ["home_id"], name: "index_reservations_on_home_id"
    t.index ["host_id"], name: "index_reservations_on_host_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "gender"
    t.date "birthdate"
    t.string "phone"
    t.string "address"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "homes", "users"
  add_foreign_key "pets", "users"
  add_foreign_key "reservations", "homes"
  add_foreign_key "reservations", "users", column: "guest_id"
  add_foreign_key "reservations", "users", column: "host_id"
end
