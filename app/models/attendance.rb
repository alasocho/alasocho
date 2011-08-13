class Attendance < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  STATES_NEEDING_ACTION = %w(invited tentative)
  STATES_INTERESTED     = %w(confirmed tentative waitlisted)

  scope :need_attention, joins(:event).where("attendances.state in (?) OR (attendances.state IN (?) AND events.last_commented_at > attendances.updated_at)", STATES_NEEDING_ACTION, STATES_INTERESTED)
end
