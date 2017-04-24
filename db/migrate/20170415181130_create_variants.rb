class CreateVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :variants do |t|
      t.string :title
      t.monetize :price, currency: { present: false }
      t.string :currency, default: 'CAD', null: false
      t.string :sku
      t.integer :position
      t.integer :grams
      t.string :option1
      t.string :option2
      t.string :option3
      t.boolean :taxable
      t.integer :inventory
      t.integer :old_inventory
      t.decimal :weight
      t.string :weight_unit
      t.references :product, index: true, allow_nil: false
      t.timestamps
    end
  end
end
