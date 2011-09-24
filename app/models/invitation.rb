class Invitation
  attr :attendance
  attr :email

  def initialize(attendance_factory, email)
    @attendance = attendance_factory.new(email: email)
    @email = email
  end

  def valid?
    attendance.valid?
  end
end
