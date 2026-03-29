class CreateTrackedItems < ActiveRecord::Migration[8.1]
  def change
    create_table :tracked_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity_needed, null: false, default: 1
      t.integer :quantity_current, null: false, default: 0

      t.timestamps
    end
  end
end
