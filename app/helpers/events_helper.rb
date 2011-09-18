module EventsHelper
  # Tagline describing the different amounts of people involved in an event.
  def tagline(event)
    counts = {
      "events.show.confirmed"  => event.confirmed_invitations.size,
      "events.show.waitlisted" => event.waitlisted_invitations.size,
      "events.show.invited"    => event.pending_invitations.size
    }

    counts.reject { |key, count| count.zero? }.map { |key, count| t(key, count: count) }.join(", ")
  end

  # If the supplied user can invite people to the event, returns a link that
  # should trigger the invitations modal dialog.
  def link_to_invite_if_allowed(event, user=current_user, options={})
    options = user if user.is_a? Hash
    options[:class] = Array.wrap(options[:class]) << "invite_more"

    if event.allow_invites_from(user)
      link_to t("events.form.invite"), new_event_invitation_path(event), options
    end
  end

  # Returns a string with the approximate duration of an event,
  # internationalized.
  def event_duration(event)
    days = hours = minutes = nil

    difference = (event.end_at - event.start_at).to_i

    days, difference = difference / 86400, difference % 86400
    hours, difference = difference / 3600, difference % 3600
    minutes, difference = difference / 60, difference % 60

    if days >= 1
      days += 1 if hours > 12 # round up
      t("events.show.duration.days", count: days)
    elsif hours < 1
      t("events.show.duration.minutes", minutes: minutes)
    else
      hours, minutes = "%02d" % hours, "%02d" % minutes
      t("events.show.duration.hours", count: hours, minutes: minutes)
    end
  end

  # If the event ends the same day it starts, returns just the time,
  # if it ends the next day, it returns the time specifying the day, else it
  # returns the full date.
  def fancy_end_at(event)
    if event.start_at + 1.day > event.end_at
      t("events.show.end_time.hours", time: event.end_at.to_s(:time),
                                      duration: event_duration(event))
    elsif event.start_at + 2.days > event.end_at
      t("events.show.end_time.next_day", time: event.end_at.to_s(:time),
                                         duration: event_duration(event))
    else
      t("events.show.end_time.arbitrary", time: l(event.end_at, format: :default))
    end
  end

  def rsvp_class(attendance)
    case attendance.state
    when "invited"; ""
    when "waitlisted";             "info"
    when "confirmed", "tentative"; "success"
    when "declined";               "error"
    end
  end

  def rsvp_status(attendance)
    case attendance.state
    when "invited";                t(".rsvp.havent_replied")
    when "waitlisted";             t(".rsvp.waitlisted")
    when "confirmed", "tentative"; t(".rsvp.confirmed")
    when "declined";               t(".rsvp.declined")
    end
  end
end
