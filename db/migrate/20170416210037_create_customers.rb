class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :company
      t.integer :orders_count, default: 0, null: false
      t.monetize :total_spent
      t.integer :last_order_id
      t.string :phone
      t.boolean :tax_exempt, default: false, null: false
      t.references :account, index: true, null: false
      t.timestamps
    end
    add_index(:customers, :email)
    add_index(:customers, [:account_id, :email], unique: true)
  end
end
