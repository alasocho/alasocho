module EventsHelper
  def tagline(event)
    counts = {
      "event.confirmed"  => event.confirmed_invitations.size,
      "event.waitlisted" => event.waitlisted_invitations.size,
      "event.invited"    => event.attendances.size
    }

    counts.reject { |key, count| count.zero? }.map { |key, count| t(key, count: count) }.join(", ")
  end
end
