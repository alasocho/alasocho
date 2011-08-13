class EventsController < ActionController::Base
  def new
    @event = Event.new #FIXME Needs current_user, right?
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:notice] = t("event.form.create.message.saved")
      redirect_to event_path(@event)
    else
      flash.now[:alert] = t("event.form.create.message.error")
      render :action => :new
    end
  end
end
