class CreateSaleTaxes < ActiveRecord::Migration[5.0]
  def change
    create_table :sale_taxes do |t|
      t.string :name
      t.decimal :percent, precision: 2, default: 0
      t.references :account, index: true, null: false
      t.timestamps
    end
  end
end
