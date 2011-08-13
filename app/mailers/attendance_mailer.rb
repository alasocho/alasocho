class AttendanceMailer < ActionMailer::Base
  default_url_options[:host] = ALasOcho.config[:canonical_host]

  def invite_notification(attendance)
    @attendance = attendance
    mail(
      :subject => t("email.attendance.invite.subject", :event_name => attendance.event.name),
      :to      => attendance.email,
      :from    => "arturito@alasocho.com"
    )
  end
end
