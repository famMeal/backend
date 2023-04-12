class CreateMeal < ActiveRecord::Migration[7.0]
  def change
    create_table :meals do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :active, null: false, default: false
      t.decimal :price, null: false, precision: 8, scale: 2

      t.references :restaurant, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
