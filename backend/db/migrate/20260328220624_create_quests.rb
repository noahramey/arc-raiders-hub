class CreateQuests < ActiveRecord::Migration[8.1]
  def change
    create_table :quests do |t|
      t.string :external_id, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :difficulty
      t.jsonb :rewards, default: {}
      t.jsonb :required_items, default: []
      t.datetime :synced_at

      t.timestamps
    end
    add_index :quests, :slug, unique: true
    add_index :quests, :external_id, unique: true
  end
end
