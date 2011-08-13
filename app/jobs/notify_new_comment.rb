class NotifyNewComment < Job
  @queue = :high

  def perform(attendance_id)
    attendance = Attendance.includes(:user, :event).find(attendance_id)
    AttendanceMailer.new_comment_notification(attendance).deliver
  end
end

