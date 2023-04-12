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

ActiveRecord::Schema[7.0].define(version: 2023_04_12_014802) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "meals", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.boolean "active", default: false, null: false
    t.decimal "price", precision: 8, scale: 2, null: false
    t.bigint "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_meals_on_restaurant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status", null: false
    t.datetime "pickup_start_time", null: false
    t.datetime "pickup_end_time", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "tip_amount", precision: 8, scale: 2, null: false
    t.decimal "total", precision: 8, scale: 2, null: false
    t.decimal "subtotal", precision: 8, scale: 2, null: false
    t.bigint "meal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_orders_on_meal_id"
  end

  create_table "restaurant_settings", force: :cascade do |t|
    t.datetime "order_start_time", null: false
    t.datetime "order_cutoff_time", null: false
    t.datetime "pickup_start_time", null: false
    t.datetime "pickup_end_time", null: false
    t.boolean "byob_tupperware", default: false, null: false
    t.bigint "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_restaurant_settings_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name", null: false
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "province"
    t.string "postal_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.index ["owner_id"], name: "index_restaurants_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.string "password", null: false
    t.bigint "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_users_on_restaurant_id"
  end

  add_foreign_key "meals", "restaurants", on_delete: :cascade
  add_foreign_key "orders", "meals", on_delete: :cascade
  add_foreign_key "restaurant_settings", "restaurants", on_delete: :cascade
  add_foreign_key "restaurants", "users", column: "owner_id"
  add_foreign_key "users", "restaurants"
end
