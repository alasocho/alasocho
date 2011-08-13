class EventsController < ApplicationController
  def new
    @event = current_user.hosted_events.new #FIXME Needs current_user, right?
  end

  def create
    @event = current_user.hosted_events.new(params[:event])
    if @event.save
      flash[:notice] = t("event.form.create.message.saved")
      redirect_to event_path(@event)
    else
      flash.now[:alert] = t("event.form.create.message.error")
      render :action => :new
    end
  end
end
