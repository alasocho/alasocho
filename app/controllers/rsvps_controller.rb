require "event_finders"

class RsvpsController < ApplicationController
  include EventFinders

  before_filter :authenticate_user

  def confirm
    load_event
    rsvp = Rsvp.new(Attendance.for(@event, current_user))
    rsvp.confirm
    redirect_to @event, notice: notice(rsvp.status)
  end

  def decline
    load_event
    rsvp = Rsvp.new(Attendance.for(@event, current_user))
    rsvp.decline
    redirect_to @event, notice: notice(rsvp.status)
  end

  private

  def notice(key)
    t(key, scope: "attendance.message", event_name: @event.name)
  end

  def unauthenticated_url
    event_path(params[:event_id])
  end
end
