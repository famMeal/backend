class CreateRestaurantsAndUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :country

      t.timestamps
    end

    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.string :password, null: false
      
      t.references :restaurant, index: true, foreign_key: true
      t.timestamps
    end

    add_reference :restaurants, :owner, index: true, foreign_key: { to_table: :users }
  end
end
