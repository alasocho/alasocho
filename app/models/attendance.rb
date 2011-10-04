require 'micro_machine'
require 'simple_uuid'

class Attendance < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  STATES_NEEDING_ACTION = %w(invited tentative)
  STATES_INTERESTED     = %w(confirmed tentative waitlisted)
  STATES_CONFIRMED      = %w(confirmed tentative)
  STATES_RELEVANT       = %w(confirmed waitlisted declined tentative)

  before_create :attach_to_user, :generate_token
  after_create :invite_if_published_event

  attr_accessible :email, :user_id, :state, :user

  scope :confirmed,  where(state: STATES_CONFIRMED)
  scope :pending,    where(state: "invited")
  scope :waitlisted, where(state: "waitlisted")
  scope :interested, where(state: STATES_INTERESTED)
  scope :declined,   where(state: "declined")

  scope :need_attention, lambda { joins(:event).merge(Event.viewable).where("attendances.state in (?) OR (attendances.state IN (?) AND events.last_commented_at > attendances.updated_at)", STATES_NEEDING_ACTION, STATES_INTERESTED) }
  scope :need_action, where("attendances.state in (?)", STATES_NEEDING_ACTION)

  scope :not_visited_after, lambda { |datetime| where("attendances.updated_at < ?", datetime) }

  scope :user_wants_comment_notifications, joins(:user).merge(User.want_comment_notifications)

  validates :user_id, :uniqueness => { :scope => :event_id, :allow_nil => true }
  validates :email, :uniqueness => { :scope => :event_id, :allow_nil => true },
                    :format => { :with => /\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i, :allow_nil => true }

  def self.for(event, user)
    event.attendances.find_by_user_id(user.to_param) ||
      event.attendances.new(user_id: user.to_param, state: "invited")
  end

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
    state.trigger(:invite)
    save!(:validate => false)
    send_invite_email unless !user.nil? && user.email == event.host.email
  end

  def confirm!
    state.trigger(:confirm)
    self.confirmed_at = Time.current
    save!(:validate => false)
  end

  def waitlist!
    state.trigger(:waitlist)
    save!(:validate => false)
  end

  def decline!
    state.trigger(:decline)
    save!(:validate => false)

    event.process_waitlist
  end

  def reserve_slot!
    state.trigger(:reserve_slot)
    save(:validate => false)
    NotifyOfTentativeState.enqueue(id)
  end

  def state
    @_state ||= MicroMachine.new(self[:state]).tap do |machine|
      machine.transitions_for[:invite]       = { "added" => "invited" }
      machine.transitions_for[:confirm]      = { "invited" => "confirmed", "declined" => "confirmed", "tentative" => "confirmed" }
      machine.transitions_for[:decline]      = { "invited" => "declined", "waitlisted" => "declined", "tentative" => "declined", "confirmed" => "declined" }
      machine.transitions_for[:waitlist]     = { "invited" => "waitlisted", "declined" => "waitlisted" }
      machine.transitions_for[:reserve_slot] = { "waitlisted" => "tentative" }
      machine.on(:invited) { send_invite_email }
      machine.on(:any) { self[:state] = state.state }
    end
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
    state == "confirmed"
  end

  def waitlisted?
    state == "waitlisted"
  end

  def tentative?
    state == "tentative"
  end

  def declined?
    state == "declined"
  end

  def generate_token
    self.token = SimpleUUID::UUID.new.to_guid
  end

  def invite_if_published_event
    invite! if state == "added" && event.published?
  end
end
