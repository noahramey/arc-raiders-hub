class CreateTraders < ActiveRecord::Migration[8.1]
  def change
    create_table :traders do |t|
      t.string :external_id, null: false
      t.string :name, null: false
      t.jsonb :inventory, default: []
      t.datetime :synced_at

      t.timestamps
    end
    add_index :traders, :external_id, unique: true
  end
end
