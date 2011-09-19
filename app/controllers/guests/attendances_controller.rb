require "event_finders"

class Guests::AttendancesController < ApplicationController
  include EventFinders

  def confirm
    load_own_event
    load_attendance

    if @event.slots_available?
      @attendance.confirm!
    else
      @attendance.waitlist!
    end

    render partial: "attendances/attendance", object: @attendance, locals: { management: true }
  end

  def decline
    load_own_event
    load_attendance

    @attendance.decline!

    render partial: "attendances/attendance", object: @attendance, locals: { management: true }
  end

  private

  def load_attendance
    @attendance = @event.attendances.find(params[:attendance_id])
  end
end
