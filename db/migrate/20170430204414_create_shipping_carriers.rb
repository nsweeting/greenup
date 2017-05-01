class CreateShippingCarriers < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_carriers do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
