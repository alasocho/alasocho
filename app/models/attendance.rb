require 'micromachine'
require 'simple_uuid'

class Attendance < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  STATES_NEEDING_ACTION = %w(invited tentative)
  STATES_INTERESTED     = %w(confirmed tentative waitlisted)
  STATES_CONFIRMED      = %w(confirmed tentative)

  before_save :preserve_state_machine
  before_create :attach_to_user, :generate_token

  attr_accessible :email, :user_id, :state

  scope :need_attention, joins(:event).where("attendances.state in (?) OR (attendances.state IN (?) AND events.last_commented_at > attendances.updated_at)", STATES_NEEDING_ACTION, STATES_INTERESTED)
  scope :need_action, where("attendances.state in (?)", STATES_NEEDING_ACTION)

  def invite!
    state_machine.trigger(:invite)
    save(:validate => false)
  end

  def confirm!
    state_machine.trigger(:confirm)
    save(:validate => false)
  end

  def waitlist!
    state_machine.trigger(:waitlist)
    save(:validate => false)
  end

  def decline!
    state_machine.trigger(:decline)
    save(:validate => false)

    if !event.atendee_quota.nil? && event.available_slots > 0 && event.waitlisted.size > 0
      event.waitlisted.first.reserve_slot!
    end
  end

  def reserve_slot!
    state_machine.trigger(:reserve_slot)
    save(:validate => false)
    NotifyOfTentativeState.enqueue(id)
  end

  def state_machine
    @state_machine ||= MicroMachine.new(state || "added").tap do |machine|
      machine.transitions_for[:invite]       = { "added" => "invited" }
      machine.transitions_for[:confirm]      = { "invited" => "confirmed", "declined" => "confirmed", "tentative" => "confirmed" }
      machine.transitions_for[:decline]      = { "invited" => "declined", "waitlisted" => "declined", "tentative" => "declined", "confirmed" => "declined" }
      machine.transitions_for[:waitlist]     = { "invited" => "waitlisted", "declined" => "waitlisted" }
      machine.transitions_for[:reserve_slot] = { "waitlisted" => "tentative" }
      machine.on(:invited) { send_invite_email }
    end
  end

  def preserve_state_machine
    self.state = state_machine.state
  end

  def send_invite_email
    NotifyInvite.enqueue(id)
  end

  def attach_to_user
    user = User.where(:email => email).first
    return unless user.present?
    self.user = user
  end

  def confirmed?
    state_machine.state == "confirmed"
  end

  def declined?
    state_machine.state == "confirmed"
  end

  def generate_token
    self.token = SimpleUUID::UUID.new.to_guid
  end
end
