class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :body_html
      t.string :product_type
      t.string :slug
      t.string :vendor
      t.boolean :published, default: false, null: false
      t.integer :published_scope, default: 0, null: false
      t.timestamp :published_at
      t.references :account, index: true, allow_nil: false
      t.timestamps
    end
  end
end
