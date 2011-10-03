class Rsvp
  attr :attendance
  attr :event

  def initialize(event, attendance)
    @attendance = attendance
    @event = event
  end

  def confirm
    if event.slots_available?
      attendance.confirm!
    else
      attendance.waitlist!
    end
  end

  def decline
    attendance.decline!
  end

  def status
    attendance.state.to_s
  end

  def replied?
    attendance.persisted?
  end
end
