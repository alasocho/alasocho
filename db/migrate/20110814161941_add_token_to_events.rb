class AddTokenToEvents < ActiveRecord::Migration
  def change
    add_column :events, :token, :string
  end
end
