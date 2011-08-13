class AddDefaultToStates < ActiveRecord::Migration
  def up
    change_column :events, :state, :string, :default => "created"
    change_column :attendances, :state, :string, :default => "added"
  end

  def down
    change_column :attendances, :state, :string
    change_column :events, :state, :string
  end
end
