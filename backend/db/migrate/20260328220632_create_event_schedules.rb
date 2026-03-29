class CreateEventSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :event_schedules do |t|
      t.string :name, null: false
      t.jsonb :schedule, default: {}
      t.datetime :synced_at

      t.timestamps
    end
  end
end
