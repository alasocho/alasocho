require 'micromachine'
require 'simple_uuid'

class Attendance < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  STATES_NEEDING_ACTION = %w(invited tentative)
  STATES_INTERESTED     = %w(confirmed tentative waitlisted)
  STATES_CONFIRMED      = %w(confirmed tentative)
  STATES_RELEVANT       = %w(confirmed waitlisted declined tentative)

  before_save :preserve_state_machine
  before_create :attach_to_user, :generate_token
  after_create :invite_if_published_event

  attr_accessible :email, :user_id, :state, :user

  scope :need_attention, lambda { joins(:event).merge(Event.viewable).where("attendances.state in (?) OR (attendances.state IN (?) AND events.last_commented_at > attendances.updated_at)", STATES_NEEDING_ACTION, STATES_INTERESTED) }
  scope :need_action, where("attendances.state in (?)", STATES_NEEDING_ACTION)

  scope :not_visited_after, lambda { |datetime| where("attendances.updated_at < ?", datetime) }

  scope :user_wants_comment_notifications, joins(:user).merge(User.want_comment_notifications)

  validates :user_id, :uniqueness => { :scope => :event_id, :allow_nil => true }
  validates :email, :uniqueness => { :scope => :event_id, :allow_nil => true }

  def recipient
    user && user.email || self[:email]
  end

  def owner
    user || User::Anonymous.new(self)
  end

  def need_action?
    STATES_NEEDING_ACTION.include?(state)
  end

  def invite!
    state_machine.trigger(:invite)
    save!(:validate => false)
    send_invite_email unless !user.nil? && user.email == event.host.email
  end

  def confirm!
    state_machine.trigger(:confirm)
    self.confirmed_at = Time.current
    save!(:validate => false)
  end

  def waitlist!
    state_machine.trigger(:waitlist)
    save!(:validate => false)
  end

  def decline!
    state_machine.trigger(:decline)
    save!(:validate => false)

    event.process_waitlist
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

  def send_event_cancelled_email
    NotifyEventCancelled.enqueue(id)
  end

  def send_new_comment_email
    if recipient.present?
      NotifyNewComment.enqueue(id)
    else
      logger.error "Can't deliver comment notification for #{id} because #{user.name} doesn't have an email"
      return
    end
  end

  def attach_to_user
    return if user.present? || user_id.present?
    user = User.where(:email => email).first
    return unless user.present?
    self.user = user
  end

  def confirmed?
    state_machine.state == "confirmed"
  end

  def waitlisted?
    state_machine.state == "waitlisted"
  end

  def tentative?
    state_machine.state == "tentative"
  end

  def declined?
    state_machine.state == "declined"
  end

  def generate_token
    self.token = SimpleUUID::UUID.new.to_guid
  end

  def invite_if_published_event
    if self.state == "added" && self.event.state == "published"
      self.invite!
    end
  end
end
