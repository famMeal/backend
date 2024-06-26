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

ActiveRecord::Schema[7.0].define(version: 2024_05_26_194453) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connect_stripe_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "restaurant_id", null: false
    t.string "stripe_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_connect_stripe_accounts_on_restaurant_id"
    t.index ["user_id"], name: "index_connect_stripe_accounts_on_user_id"
  end

  create_table "meals", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.boolean "active", default: false, null: false
    t.boolean "archived", default: false, null: false
    t.decimal "price", precision: 8, scale: 2, default: "0.0", null: false
    t.bigint "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_meals_on_restaurant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status", default: "cart", null: false
    t.datetime "pickup_start_time", null: false
    t.datetime "pickup_end_time", null: false
    t.datetime "order_placed_at"
    t.integer "quantity", default: 1, null: false
    t.integer "tip_percentage"
    t.decimal "tip_amount", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "subtotal", precision: 8, scale: 2, default: "0.0", null: false
    t.bigint "meal_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_orders_on_meal_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "restaurant_settings", force: :cascade do |t|
    t.integer "quantity_available", null: false
    t.datetime "order_start_time", null: false
    t.datetime "order_cutoff_time", null: false
    t.datetime "pickup_start_time", null: false
    t.datetime "pickup_end_time", null: false
    t.bigint "restaurant_id", null: false
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
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "stripe_account_id"
    t.string "certificate_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.boolean "is_store_owner", default: false, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "customer_stripe_account_id"
    t.json "tokens"
    t.bigint "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["restaurant_id"], name: "index_users_on_restaurant_id"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "connect_stripe_accounts", "restaurants", on_delete: :cascade
  add_foreign_key "connect_stripe_accounts", "users", on_delete: :cascade
  add_foreign_key "meals", "restaurants", on_delete: :cascade
  add_foreign_key "orders", "meals", on_delete: :cascade
  add_foreign_key "orders", "users", on_delete: :cascade
  add_foreign_key "restaurant_settings", "restaurants", on_delete: :cascade
  add_foreign_key "users", "restaurants"
end
