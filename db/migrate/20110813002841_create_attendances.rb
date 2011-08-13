class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :state
      t.datetime :confirmed_at
      t.datetime :declined_at
      t.datetime :waitlisted_at

      t.timestamps
    end
  end
end
