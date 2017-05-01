class CreateShippingService < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_services do |t|
      t.string :name
      t.string :company
      t.string :description
      t.references :shipping_carrier, index: true, null: false
      t.timestamps null: false
    end
  end
end
