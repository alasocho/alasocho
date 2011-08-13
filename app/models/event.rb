require 'micromachine'

class Event < ActiveRecord::Base
  has_many :attendances
  has_many :comments

  before_save :preserve_state_machine

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
