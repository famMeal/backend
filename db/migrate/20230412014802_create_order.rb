class CreateOrder < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :status, null: false, default: "cart"
      t.datetime :pickup_start_time, null: false
      t.datetime :pickup_end_time, null: false
      t.datetime :order_placed_at
      t.integer :quantity, null: false, default: 1
      t.integer :tip_percentage
      t.decimal :tip_amount, null: false, precision: 8, scale: 2, default: 0.00
      t.decimal :total, null: false, precision: 8, scale: 2, default: 0.00
      t.decimal :subtotal, null: false, precision: 8, scale: 2, default: 0.00
     
      t.references :meal, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.references :user, index: true, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
