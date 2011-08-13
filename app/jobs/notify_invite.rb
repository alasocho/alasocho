class NotifyInvite < Job
  @queue = :high

  def perform(attendance_id)
    attendance = Attendance.includes(:user).find(attendance_id)
    AttendanceMailer.invite_notification(attendance).deliver
  end
end
