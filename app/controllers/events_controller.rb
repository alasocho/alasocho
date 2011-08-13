class EventsController < ApplicationController
  before_filter :authenticate_user, :except => :show
  before_filter :load_event, :only => [:invite_people, :update, :show, :invite]

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

  def invite
    list = JSON params[:invitees]
    @event.invitee_list = list
    @event.save
    respond_to do |format|
      format.json { render :json => "OK"}
    end
  end

  def update
    @event.update_attributes(params[:event])

    if @event.save
      @event.publish!
      flash[:notice] = t("event.form.invite.message.success")
      redirect_to @event
    else
      flash.now[:alert] = t("event.form.invite.message.error")
      render :action => :invite_people
    end
  end

  def show
    @comments = @event.comments
  end

private

  def load_event
    @event = current_user.hosted_events.find(params[:event_id] || params[:id])
  end
end
