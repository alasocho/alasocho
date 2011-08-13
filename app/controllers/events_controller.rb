class EventsController < ApplicationController
  before_filter :load_event, :only => [:invite_people, :update]

  def new
    @event = current_user.hosted_events.new #FIXME Needs current_user, right?
  end

  def create
    @event = current_user.hosted_events.new(params[:event])
    if @event.save
      flash[:notice] = t("event.form.create.message.success")
      redirect_to event_invite_people_path(@event)
    else
      flash.now[:alert] = t("event.form.create.message.error")
      render :action => :new
    end
  end

  def invite_people

  end

  def update
    @event.update_attributes(params[:event])
    if @event.save
      flash[:notice] = t("event.form.invite.message.success")
      redirect_to @event
    else
      flash.now[:alert] = t("event.form.invite.message.error")
      render :action => :invite_people
    end
  end

private

  def load_event
    @event = current_user.hosted_events.find(params[:event_id] || params[:id])
  end
end
