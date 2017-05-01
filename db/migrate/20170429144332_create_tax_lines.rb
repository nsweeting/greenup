class CreateTaxLines < ActiveRecord::Migration[5.0]
  def change
    create_table :tax_lines do |t|
      t.string :name
      t.monetize :price, currency: { present: false }
      t.decimal :amount, precision: 8, scale: 5, default: 0.0
      t.string :currency, default: 'CAD', null: false
      t.references :taxable, polymorphic: true
      t.timestamps null: false
    end
  end
end
