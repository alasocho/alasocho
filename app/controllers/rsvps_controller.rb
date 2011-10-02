require "event_finders"

class RsvpsController < ApplicationController
  include EventFinders

  before_filter :authenticate_user

  def confirm
    load_event_and_attendance
    rsvp = Rsvp.new(@attendance, @event)
    rsvp.confirm
    redirect_to @event, notice: notice(rsvp.status)
  end

  def decline
    load_event_and_attendance
    rsvp = Rsvp.new(@attendance, @event)
    rsvp.decline
    redirect_to @event, notice: notice(rsvp.status)
  end

  private

  def load_event_and_attendance
    load_event
    @attendance = @event.attendance_for(current_user)
  end

  def notice(key)
    t(key, scope: "attendance.message", event_name: @event.name)
  end

  def unauthenticated_url
    event_path(params[:event_id])
  end
end
