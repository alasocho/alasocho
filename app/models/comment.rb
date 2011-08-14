class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  attr_accessible :text

  after_create :send_comment_notifications

  validates :user_id, :event_id, :text, :presence => true

  def send_comment_notifications
    attendances_to_notify.each(&:send_new_comment_email)
    event.touch(:last_commented_at)
  end

  def attendances_to_notify
    event.interested_invitations.not_visited_after(event.last_commented_at).user_wants_comment_notifications
  end
end
