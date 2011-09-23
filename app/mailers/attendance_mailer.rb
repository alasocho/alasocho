class AttendanceMailer < ActionMailer::Base
  default_url_options[:host] = ALasOcho.config[:canonical_host]

  default from: "arturito@alasocho.com"

  helper :events

  def invite_notification(attendance)
    @attendance = attendance
    @email = attendance.email

    mail(
      :subject => t("attendance_mailer.invite_notification.subject", event_name: attendance.event.name),
      :to      => attendance.email
    )
  end

  def tentative_notification(attendance)
    @attendance = attendance
    mail(
      :subject => t("email.attendance.tentative.subject", :event_name => attendance.event.name),
      :to      => attendance.user.try(:email) || attendance.email
    )
  end

  def event_cancelled_notification(attendance)
    @attendance = attendance
    mail(
      :subject => t("email.event_cancelled.subject", :event_name => attendance.event.name),
      :to      => attendance.user.try(:email) || attendance.email
    )
  end

  def date_change_notification(attendance)
    @attendance = attendance
    mail(
      :subject => t("email.attendance.date_change.subject", :event_name => attendance.event.name),
      :to      => attendance.user.try(:email) || attendance.email
    )
  end

  def new_comment_notification(attendance)
    @attendance = attendance
    @event = attendance.event

    mail(
      :subject => t("attendance_mailer.new_comment_notification.subject", :event_name => @event.name),
      :to      => attendance.user.try(:email) || attendance.email
    )
  end
end
