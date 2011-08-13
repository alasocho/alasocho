class AddEmailToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :email, :string
  end
end
