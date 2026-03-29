class CreateArcs < ActiveRecord::Migration[8.1]
  def change
    create_table :arcs do |t|
      t.string :external_id, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.jsonb :loot, default: []
      t.datetime :synced_at

      t.timestamps
    end
    add_index :arcs, :slug, unique: true
    add_index :arcs, :external_id, unique: true
  end
end
