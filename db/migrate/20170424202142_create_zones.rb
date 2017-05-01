class CreateZones < ActiveRecord::Migration[5.0]
  def change
    create_table :zones do |t|
      t.string :name, null: false
      t.string :description
      t.references :account, index: true, null: false
      t.timestamps
    end
  end
end
