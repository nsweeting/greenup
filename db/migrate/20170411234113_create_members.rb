class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.integer :user_id
      t.integer :account_id
      t.boolean :confirmed, default: false
      t.string :confirmation_email
      t.integer :role, default: 0, null: false
      t.text :scopes, array: true, default: []
      t.timestamps
    end
    add_index(:members, :user_id)
    add_index(:members, :account_id)
    add_index(:members, [:user_id, :account_id], unique: true)
  end
end
