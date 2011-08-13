require 'micromachine'

class Event < ActiveRecord::Base
  has_many :attendances

  has_many :confirmed_invitations, :class_name => "Attendance", :conditions => { :state => Attendance::STATES_CONFIRMED }
  has_many :confirmed_attendees, :through => :confirmed_invitations, :source => :user

  has_many :pending_invitations, :class_name => "Attendance", :conditions => { :state => "invited" }
  has_many :invitees, :through => :pending_invitations, :source => :user

  has_many :waitlisted_invitations, :class_name => "Attendance", :conditions => { :state => "waitlisted" }
  has_many :waitlisted, :through => :waitlisted_invitations, :source => :user

  has_many :comments
  belongs_to :host, :class_name => "User"

  before_save :preserve_state_machine
  after_save :create_invitations

  scope :viewable_by, lambda { |user| join_attendances.where("attendances.user_id = :user_id or events.host_id = :user_id or events.public is true", :user_id => user.id) }
  scope :join_attendances, joins("LEFT JOIN attendances on attendances.event_id = events.id")

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

  def slots_available?
    return true unless limited?
    slots_taken < attendee_quota
  end

  def slots_taken
    confirmed_invitations.count
  end

  def slots_available_count
    attendee_quota - slots_taken
  end

  def limited?
    attendee_quota.present?
  end

  def available_slots
    return  1 if self.attendee_quota.nil?

    attendee_quota - slots_taken
  end
end
