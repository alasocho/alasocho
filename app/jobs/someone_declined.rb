class SomeoneDeclined < Job
  @queue = :high

  def perform(attendance_id, declined_user_id)
    attendance = Attendance.includes(:user, :event).find(attendance_id)
    declined_user = User.find(declined_user_id)
    AttendanceMailer.someone_declined_notification(attendance, declined_user).deliver
  end
end
