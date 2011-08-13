class EventsController < ActionController::Base
  def new
    @event = Event.new #FIXME Needs current_user, right?
  end

  def create
    @event = Event.new(params[:event])
    # FIXME flashes
    if @event.save
      redirect_to event_path(@event)
    else
      render :action => :new
    end
  end
end
