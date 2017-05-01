class CreateTaxRates < ActiveRecord::Migration[5.0]
  def change
    create_table :tax_rates do |t|
      t.string :name
      t.decimal :amount, precision: 8, scale: 5, default: 0.0
      t.references :zone, index: true, null: false
      t.references :account, index: true, null: false
      t.timestamps
    end
  end
end
