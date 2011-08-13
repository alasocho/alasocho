class AttendanceMailer < ActionMailer::Base
  def invite_notification(attendance)
    @attendance = attendance
    mail(
      :subject => t("email.attendance.invite.subject", :event_name => attendance.event.name),
      :to      => attendance.email,
      :from    => "arturito@alasocho.com"
    )
  end
end
