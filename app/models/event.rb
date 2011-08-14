require 'micromachine'

class Event < ActiveRecord::Base
  VIEWABLE_STATES = %w(published cancelled)

  has_many :attendances

  has_many :confirmed_invitations, :class_name => "Attendance", :conditions => { :state => Attendance::STATES_CONFIRMED }
  has_many :confirmed_attendees, :through => :confirmed_invitations, :source => :user

  has_many :pending_invitations, :class_name => "Attendance", :conditions => { :state => "invited" }
  has_many :invitees, :through => :pending_invitations, :source => :user

  has_many :waitlisted_invitations, :class_name => "Attendance", :conditions => { :state => "waitlisted" }
  has_many :waitlisted, :through => :waitlisted_invitations, :source => :user

  has_many :interested_invitations, :class_name => "Attendance", :conditions => { :state => Attendance::STATES_INTERESTED }
  has_many :interested, :through => :interested_invitations, :source => :user

  has_many :comments
  belongs_to :host, :class_name => "User"

  before_save :preserve_state_machine
  after_save :create_invitations
  before_create :default_last_commented_at

  scope :join_attendances, joins("LEFT JOIN attendances on attendances.event_id = events.id")

  def self.viewable_by(user)
    join_attendances.where("events.host_id = :user_id or ((attendances.user_id = :user_id or events.public is true) and events.state in (:states))",
                           :user_id => user.id, :states => VIEWABLE_STATES)
  end

  validates :name, :start_at, :presence => true
  validates :attendee_quota, :numericality => {
    :only_integer => true,
    :greater_than => lambda{|record| record.confirmed_attendees.size},
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

  def preserve_state_machine
    self.state = state_machine.state
  end

  def create_invitations
    invitee_list.each { |email| create_invitation(email) } if invitee_list.present?
  end

  def create_invitation(email)
    attendances.create(:email => email.strip) if !email.strip.empty?
  end

  def attendance_for(user)
    attendances.where(:user_id => user).first || public_attendance_for(user)
  end

  def public_attendance_for(user)
    public? ? attendances.new(:user_id => user.id, :state => "invited") : nil
  end

  def allow_invites_from(user)
    self.public or allow_invites or host == user
  end

  def slots_available?
    return true unless limited?
    slots_taken < attendee_quota
  end

  def slots_taken
    confirmed_invitations.count
  end

  def slots_available_count
    available_slots # FIXME: Remove this, I just don't want to grep anymore :(
  end

  def limited?
    attendee_quota.present?
  end

  def available_slots
    return 1 unless limited?

    attendee_quota - slots_taken
  end

  def process_waitlist
    if limited? && event.available_slots > 0 && event.waitlisted.size > 0
      event.waitlisted.first.reserve_slot!
    end
  end

  def default_last_commented_at
    self.default_last_commented_at ||= Time.now
  end
end
