class AddEventIdIndexOnAttendances < ActiveRecord::Migration
  def change
    add_index :attendances, :event_id
  end
end
