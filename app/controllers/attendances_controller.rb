class AttendancesController < ApplicationController
  before_filter :load_event_and_attendance

  def create
    if @event.slots_available?
      flash[:notice] = t("attendance.message.confirm", :event_name => @event.name)
      @attendance.confirm!
    else
      flash[:notice] = t("attendance.message.waitlist", :event_name => @event.name)
      @attendance.waitlist!
    end
    redirect_to @event
  end

  def destroy
    @attendance.decline!
    flash[:notice] = t("attendance.message.decline", :event_name => @event.name)
    redirect_to @event
  end

private
  def load_event_and_attendance
    @event = Event.find(params[:event_id])
    @attendance = @event.attendance_for(current_user)
  end
end
