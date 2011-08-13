class EventsController < ActionController::Base
  def new
    @event = Event.new #FIXME Needs current_user, right?
  end

  def create
  end
end
