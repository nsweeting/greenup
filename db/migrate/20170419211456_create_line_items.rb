class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.string :title
      t.string :variant_title
      t.string :vendor
      t.string :name
      t.integer :grams, default: 0, null: false
      t.integer :quantity, default: 1, null: false
      t.monetize :price, currency: { present: false }
      t.monetize :total_discount, currency: { present: false }
      t.string :currency, default: 'CAD', null: false
      t.boolean :taxable, default: true, null: false
      t.boolean :requires_shipping, default: true, null: false
      t.references :order, index: true
      t.references :variant, index: true
      t.timestamps
    end
  end
end
