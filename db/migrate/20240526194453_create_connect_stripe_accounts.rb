class CreateConnectStripeAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :connect_stripe_accounts do |t|
      t.references :user, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.references :restaurant, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.string :stripe_account_id, null: false
      
      t.timestamps
    end
  end
end
