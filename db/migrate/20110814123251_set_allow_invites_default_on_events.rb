class SetAllowInvitesDefaultOnEvents < ActiveRecord::Migration
  def change
    change_column :events, :allow_invites, :boolean, :default => true
    Event.where(:public => true).update_all(:allow_invites => true)
  end
end
