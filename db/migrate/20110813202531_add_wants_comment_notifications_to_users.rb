class AddWantsCommentNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wants_comment_notifications, :boolean, :default => true
  end
end
