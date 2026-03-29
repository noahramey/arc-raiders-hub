class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :external_id, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :rarity
      t.string :category
      t.string :item_type
      t.string :image_url
      t.jsonb :meta, default: {}
      t.datetime :synced_at

      t.timestamps
    end
    add_index :items, :slug, unique: true
    add_index :items, :external_id, unique: true
  end
end
