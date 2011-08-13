require 'micromachine'

class Event < ActiveRecord::Base
  has_many :attendances
  has_many :comments
  belongs_to :host, :class_name => "User"

  before_save :preserve_state_machine

  validates :name, :start_at, :presence => true

  attr_accessible :name, :description, :start_at, :end_at, :location, :city, :public, :allow_invites, :attendee_quota, :invitee_list

  attr_accessor :invitee_list

  def state_machine
    @state_machine ||= MicroMachine.new(state || "created").tap do |machine|
      machine.transitions_for[:publish] = { "created" => "published" }
      machine.transitions_for[:cancel]  = { "created" => "cancelled", "published" => "cancelled" }
    end
  end

  def preserve_state_machine
    self.state = state_machine.state
  end
end
