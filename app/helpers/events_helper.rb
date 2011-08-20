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
  def link_to_invite_if_allowed(event, user=current_user)
    if event.allow_invites_from(user)
      link_to t("events.form.invite"), event_invite_people_path(event), class: "invite_more"
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

  def time_select(name_prefix)
    time = lambda do |hours, minutes|
      am = (hours / 12).zero?
      showable_hours = (hours % 12).zero? ? 12 : (hours % 12)

      ["#{"%02d" % (showable_hours)}:#{"%02d" % minutes} #{am ? "am" : "pm"}",
       "#{"%02d" % hours}:#{"%02d" % minutes}"]
    end

    options = (0..23).map { |hour| [time[hour, 0], time[hour, 30]] }.flatten(1)

    select_tag "#{name_prefix}_time", options_for_select(options), name: ""
  end

  def js_date_format
    t("date.formats.default").gsub(/%(.)/, '\1\1').downcase
  end
end
