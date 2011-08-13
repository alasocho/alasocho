class NotifyOfTentativeState < Job
  @queue = :high

  def perform(attendance_id)
    attendance = Attendance.includes(:user, :event).find(attendance_id)
    AttendanceMailer.tentative_notification(attendance).deliver
  end
end
