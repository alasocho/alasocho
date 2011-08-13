class AddLastCommentedAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :last_commented_at, :datetime
  end
end
