class CreateShippingMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_methods do |t|
      t.string :name
      t.references :shipping_service, index: true, null: false
      t.references :zone, index: true, null: false
      t.references :account, index: true, null: false
      t.timestamps
    end
  end
end
