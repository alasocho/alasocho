class Rsvp
  attr :attendance

  delegate :event, to: :attendance

  def initialize(attendance)
    @attendance = attendance
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

  def positive?
    %w(confirmed waitlisted).include?(status)
  end

  def negative?
    %w(declined).include?(status)
  end

  def replied?
    attendance.persisted?
  end
end
