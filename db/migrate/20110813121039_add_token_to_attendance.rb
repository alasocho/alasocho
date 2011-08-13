class AddTokenToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :token, :string
  end
end
