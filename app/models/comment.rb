class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  attr_accessible :text

  after_create :send_comment_notifications

  def send_comment_notifications
    event.interested_invitations.not_visited_after(event.last_commented_at).each(&:send_new_comment_email)
    event.touch(:last_commented_at)
  end
end
