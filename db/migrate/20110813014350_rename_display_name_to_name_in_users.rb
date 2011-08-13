class RenameDisplayNameToNameInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :display_name, :name
  end
end
