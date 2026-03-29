class CreateMapData < ActiveRecord::Migration[8.1]
  def change
    create_table :map_data do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.jsonb :data, default: {}
      t.datetime :synced_at

      t.timestamps
    end
    add_index :map_data, :slug, unique: true
  end
end
