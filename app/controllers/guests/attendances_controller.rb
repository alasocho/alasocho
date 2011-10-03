require "event_finders"

class Guests::AttendancesController < ApplicationController
  include EventFinders

  def confirm
    load_own_event
    load_attendance
    rsvp = Rsvp.new(@attendance)
    rsvp.confirm
    render partial: "attendances/attendance", object: @attendance, locals: { management: true }
  end

  def decline
    load_own_event
    load_attendance
    rsvp = Rsvp.new(@attendance)
    rsvp.decline
    render partial: "attendances/attendance", object: @attendance, locals: { management: true }
  end

  private

  def load_attendance
    @attendance = @event.attendances.find(params[:attendance_id])
  end
end
