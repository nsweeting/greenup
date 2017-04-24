class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :company
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :postal_code
      t.integer :category, default: 0, null: false
      t.references :addressable, index: true, polymorphic: true
      t.references :province, index: true, null: false
      t.references :country, index: true, null: false
      t.timestamps
    end
  end
end
