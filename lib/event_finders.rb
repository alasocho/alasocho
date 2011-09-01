# Include this module in controllers that need to load events with varying
# degrees of permissions.
module EventFinders
  # FIXME: Please review the scopes so we can avoid the read-only fetch and can
  # drop support for #load_event_writable
  def load_event
    id, token = (params[:event_id] || params[:id]).split('-')
    @event = (signed_in? ? Event.viewable_by(current_user, token) : Event.public_events(token)).find(id)
  end

  def load_own_event
    @event = current_user.hosted_events.find(params[:event_id] || params[:id])
  end

  def load_event_writable
    load_event
    @event = Event.find(@event.id)
  end
end
