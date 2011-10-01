module ALasOcho::EventOrganizing
  def host_event(event)
    event.host = self
    event.attendances.host = self
    event.save
  ensure
    return event
  end
end
