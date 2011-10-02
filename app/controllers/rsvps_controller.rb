require "event_finders"

class RsvpsController < ApplicationController
  include EventFinders

  def confirm
    load_event_and_attendance

    if @event.slots_available?
      flash[:notice] = notice(:confirm)
      @attendance.confirm!
    else
      flash[:notice] = notice(:waitlist)
      @attendance.waitlist!
    end

    redirect_to @event
  end

  def decline
    load_event_and_attendance
    @attendance.decline!
    redirect_to @event, notice: notice(:decline)
  end

  private

  def load_event_and_attendance
    load_event
    @attendance = @event.attendance_for(current_user)
  end

  def notice(key)
    t(key, scope: "attendance.message", event_name: @event.name)
  end
end
