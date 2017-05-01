class CreateZoneMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :zone_members do |t|
      t.references :zoneable, polymorphic: true
      t.references :zone
      t.timestamps null: false
    end
  end
end
