class AttendancesController < ApplicationController
  def create
    load_event_and_attendance
    if @event.slots_available?
      flash[:notice] = message(:confirm, event_name: @event.name, user_name: @attendance.owner.name)
      @attendance.confirm!
    else
      flash[:notice] = message(:waitlist, :event_name => @event.name, user_name: @attendance.owner.name)
      @attendance.waitlist!
    end
    redirect_to @event
  end

  def destroy
    load_event_and_attendance
    @attendance.decline!
    flash[:notice] = message(:decline, event_name: @event.name, user_name: @attendance.owner.name)
    redirect_to @event
  end

private
  def load_event_and_attendance
    if acting_as_host?
      @event = current_user.hosted_events.find(params[:event_id])
      @attendance = @event.attendances.find(params[:attendance_id])
    else
      @event = Event.viewable_by(current_user).find(params[:event_id])
      @attendance = @event.attendance_for(current_user)
    end
  end

  def acting_as_host?
    params[:attendance_id].present?
  end

  def message_prefix
    acting_as_host? ? "attendance.message.as_host" : "attendance.message"
  end

  def message(name, options = {})
    t("#{message_prefix}.#{name.to_s}", options)
  end
end
