class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :email
      t.timestamp :closed_at
      t.integer :number
      t.text :note
      t.integer :gateway, default: 0, null: false
      t.boolean :test, default: false, null: false
      t.monetize :total_price, currency: { present: false }
      t.monetize :subtotal_price, currency: { present: false }
      t.monetize :total_tax, currency: { present: false }
      t.monetize :total_discounts, currency: { present: false }
      t.monetize :total_line_items_price, currency: { present: false }
      t.boolean :taxes_included, default: false, null: false
      t.integer :financial_status, default: 0, null: false
      t.string :currency, default: 'CAD', null: false
      t.string :name, null: false
      t.timestamp :cancelled_at
      t.timestamp :processed_at
      t.text :cancel_reason
      t.references :account, index: true, null: false
      t.references :customer, index: true
      t.timestamps
    end
    add_index(:orders, :number)
    add_index(:orders, [:account_id, :number], unique: true)
  end
end
