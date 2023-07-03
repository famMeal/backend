class CreateRestaurantSetting < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurant_settings do |t|
      t.integer :quantity_available, null: false
      t.datetime :order_start_time, null: false
      t.datetime :order_cutoff_time, null: false
      t.datetime :pickup_start_time, null: false
      t.datetime :pickup_end_time, null: false
      t.boolean :byob_tupperware, null: false, default: false

      t.references :restaurant, index: true, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
