require 'micromachine'
require 'ri_cal'

class Event < ActiveRecord::Base

  VIEWABLE_STATES = %w(published cancelled)

  has_many :attendances


  # FIXME: These five methods want to be removed. But let's first make sure they're not being used anywhere by inlining them.
  def waitlisted_invitations
    attendances.waitlisted
  end

  def interested_invitations
    attendances.interested
  end

  def declined_invitations
    attendances.declined
  end

  has_many :comments, :order => "comments.created_at desc"
  belongs_to :host, :class_name => "User"

  before_save :preserve_state_machine, :check_if_public
  after_save :create_invitations
  before_create :set_default_last_commented_at
  after_create :set_token

  scope :join_attendances, joins("LEFT JOIN attendances on attendances.event_id = events.id")
  scope :viewable, lambda {  where(state: VIEWABLE_STATES) }
  scope :future, where("start_at > ?", 3.hours.ago) #well, sort of

  def self.public_events(token=nil)
    (token.present? ? where("events.public is true or events.token = :token", token: token) : where(public: true)).viewable.order("start_at")
  end

  def self.viewable_by(user, token = nil)
    join_attendances.where("events.host_id = :user_id or ((attendances.user_id = :user_id or events.public is true or events.token = :token)  and events.state in (:states))",
                           user_id: user.id, states: VIEWABLE_STATES, token: token)
  end

  validates :name, :start_at, :presence => true
  validates :attendee_quota, :numericality => {
    :only_integer => true,
    :greater_or_equal_than => lambda{|record| record.attendances.confirmed.size},
    :allow_nil => true
  }

  attr_accessible :name, :description, :start_at, :end_at, :location, :city, :public, :allow_invites, :attendee_quota, :invitee_list

  attr_accessor :invitee_list

  def publish!
    state_machine.trigger(:publish)
    save(:validate => false)
    attendances.each(&:invite!)
  end

  def cancel!
    state_machine.trigger(:cancel)
    save!(:validate => false)
    interested_invitations.each(&:send_event_cancelled_email)
  end

  def state_machine
    @state_machine ||= MicroMachine.new(state || "created").tap do |machine|
      machine.transitions_for[:publish] = { "created" => "published" }
      machine.transitions_for[:cancel]  = { "created" => "cancelled", "published" => "cancelled" }
    end
  end

  def viewable?
    VIEWABLE_STATES.include? state
  end

  def published?
    state == "published"
  end

  def location
    self[:location].presence || I18n.t("activerecord.defaults.event.location")
  end

  def timezone
    @_timezone ||= Timezone.get(self[:timezone])
  end

  def timezone=(tz)
    self[:timezone] = tz.respond_to?(:to_str) ? tz.to_str : tz.identifier
  end

  def check_if_public
    self.allow_invites = true if public?
  end

  def preserve_state_machine
    self.state = state_machine.state
  end

  def create_invitations
    invitee_list.each { |email| create_invitation(email) } if invitee_list.present?
  end

  def create_invitation(email)
    attendances.create(:email => email.strip) if !email.strip.empty?
  end

  def self.public_events_near(city)
    public_events.where(:city => city)
  end

  def attendance_for(user)
    attendances.where(:user_id => user.id).first || public_attendance_for(user)
  end

  def public_attendance_for(user)
    attendances.new(:user_id => user.id, :state => "invited")
  end

  def allow_invites_from(user)
    public? || allow_invites || host == user
  end

  def allow_edits_by(user)
    host == user
  end

  def slots_available?
    return true unless limited?
    slots_taken < attendee_quota
  end

  def slots_taken
    attendances.confirmed.count
  end

  def limited?
    attendee_quota.present?
  end

  def open?
    attendee_quota.blank?
  end
  alias_method :open, :open?

  def open=(flag)
    self.attendee_quota = nil if flag
  end

  def available_slots
    return 1 unless limited?

    attendee_quota - slots_taken
  end

  def process_waitlist
    while limited? && available_slots > 0 && waitlisted_invitations.size > 0
      waitlisted_invitations.first.reserve_slot!
    end
  end

  def set_default_last_commented_at
    self.last_commented_at ||= Time.current
  end

  def full_address
    [self.location, self.city].compact.join(", ")
  end

  def end_at_with_default
    end_at.presence || start_at + 1.hour
  end

  def set_token
    self.token = TokenMaker.new(self).make if token.blank?
    save(:validate => false)
  end

  def to_param
    [id, token].compact.join("-")
  end
end
