class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :owner_email
      t.string :owner_name
      t.string :website
      t.timestamps
    end
    add_index(:accounts, :name, unique: true)
  end
end
