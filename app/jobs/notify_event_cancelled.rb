class NotifyEventCancelled < Job
  @queue = :high

  def perform(attendance_id)
    attendance = Attendance.includes(:user, :event).find(attendance_id)
    AttendanceMailer.event_cancelled_notification(attendance).deliver
  end
end
