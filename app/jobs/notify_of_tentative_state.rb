class NotifyOfTentativeState < Job
  @queue = :high

  def perform(attendance_id)
    attendance = Attendance.includes(:user, :email).find(attendance_id)
    AttendantMailer.invite_notification(attendance).deliver
  end
end
