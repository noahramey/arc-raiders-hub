class AddNameIndexToEventSchedules < ActiveRecord::Migration[8.1]
  def change
    add_index :event_schedules, :name, unique: true
  end
end
