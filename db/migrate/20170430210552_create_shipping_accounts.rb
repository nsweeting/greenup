class CreateShippingAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_accounts do |t|
      t.json :credentials
      t.references :shipping_carrier, index: true, null: false
      t.references :account, index: true, null: false
      t.timestamps
    end
  end
end
