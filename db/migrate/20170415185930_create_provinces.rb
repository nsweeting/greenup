class CreateProvinces < ActiveRecord::Migration[5.0]
  def change
    create_table :provinces do |t|
      t.string :name, null: false
      t.string :abbr, null: false
      t.references :country, index: true, allow_nil: false
    end
  end
end
