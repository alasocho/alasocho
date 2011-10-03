module RsvpHelper
  def confirm_button(rsvp, manager)
    available_slots = rsvp.event.available_slots

    url = if manager
      event_confirm_guest_path(event_id: rsvp.event.id, attendance_id: rsvp.attendance.id)
    else
      event_confirm_path(rsvp.event)
    end

    link_to _confirm_label(available_slots, manager), url,
      class: "small btn action success",
      method: :post,
      remote: manager
  end

  def disabled_confirm_button(rsvp, manager)
    available_slots = rsvp.event.available_slots
    content_tag(:span, _confirm_label(available_slots, manager), class: "small btn action success disabled")
  end

  def decline_button(rsvp, manager)
    url = if manager
      event_decline_guest_path(event_id: rsvp.event.id, attendance_id: rsvp.attendance.id)
    else
      event_decline_path(rsvp.event)
    end

    link_to _decline_label(manager), url,
      class: "small btn action danger",
      method: :delete,
      remote: manager
  end

  def disabled_decline_button(rsvp, manager)
    content_tag(:span, _decline_label(manager), class: "small btn action danger disabled")
  end

  private

  def _confirm_label(slots, manager)
    scope = manager ? "event.host_actions" : "event"
    t(:confirm, scope: scope, count: slots)
  end

  def _decline_label(manager)
    scope = manager ? "event.host_actions" : "event"
    t(:decline, scope: scope)
  end
end
