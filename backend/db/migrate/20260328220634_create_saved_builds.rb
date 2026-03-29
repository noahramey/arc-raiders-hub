class CreateSavedBuilds < ActiveRecord::Migration[8.1]
  def change
    create_table :saved_builds do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.jsonb :items, default: []

      t.timestamps
    end
  end
end
