require 'micro_machine'
require 'ri_cal'
require 'attendance/event_proxy_extensions'

class Event < ActiveRecord::Base
  VIEWABLE_STATES = %w(published cancelled)

  has_many :attendances, extend: ALasOcho::EventProxyExtensions

  has_many :comments, :order => "comments.created_at desc"
  belongs_to :host, :class_name => "User"

  before_save :check_if_public
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

  attr_accessible :name, :description, :start_at, :end_at, :location, :city, :public, :allow_invites, :attendee_quota, :timezone

  def self.organize_at(location)
    new(city: location.city_and_country, timezone: location.timezone.identifier)
  end

  def publish!
    state.trigger(:publish)
    save(:validate => false)
    attendances.each(&:invite!)
  end

  def cancel!
    state.trigger(:cancel)
    save!(:validate => false)
    attendances.interested.each(&:send_event_cancelled_email)
  end

  def state
    @_state ||= MicroMachine.new(self[:state] || "created").tap do |machine|
      machine.transitions_for[:publish] = { "created" => "published" }
      machine.transitions_for[:cancel]  = { "created" => "cancelled", "published" => "cancelled" }
      machine.on(:any) { self[:state] = state.state }
    end
  end

  def viewable?
    VIEWABLE_STATES.include? self[:state]
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

  def self.public_events_near(city)
    public_events.where(:city => city)
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
    while limited? && available_slots > 0 && attendances.waitlisted.size > 0
      attendances.waitlisted.first.reserve_slot!
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
