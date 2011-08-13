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

  def tentative_notification(attendance)
    @attendance = attendance
    mail(
      :subject => t("email.attendance.tentative.subject", :event_name => attendance.event.name),
      :to      => attendance.user.try(:email) || attendance.email,
      :from    => "arturito@alasocho.com"
    )
  end

  def event_cancelled_notification(attendance)
    @attendance = attendance
    mail(
      :subject => t("email.event_cancelled.subject", :event_name => attendance.event.name),
      :to      => attendance.user.try(:email) || attendance.email,
      :from    => "arturito@alasocho.com"
    )
  end
end
