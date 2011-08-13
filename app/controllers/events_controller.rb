class EventsController < ApplicationController
  before_filter :check_token, :only => [:show]
  before_filter :authenticate_user

  def new
    @event = current_user.hosted_events.new
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

  def edit
    load_own_event
  end

  def invite
    load_own_event
    list = JSON params[:invitees]
    @event.invitee_list = list
    @event.save
    respond_to do |format|
      format.json { render :json => "OK"}
    end
  end

  def my_events
    @my_events = current_user.hosted_events
    @interested_to_attend = current_user.interested_to_attend
  end

  def invite_people
    load_own_event
  end

  def update
    load_own_event
    @event.attributes = params[:event]

    date_changed = @event.start_at_changed? || @event.end_at_changed?


    if @event.save
      @event.publish!
      NotifyDateChange.enqueue(@event.id) if date_changed
      flash[:notice] = t("event.form.invite.message.success")

      redirect_to @event
    else
      flash.now[:alert] = t("event.form.invite.message.error")
      render :action => :invite_people
    end
  end

  def show
    load_event
    @attendance = @event.attendance_for(current_user)
    @comments = @event.comments
  end

  def destroy
    load_own_event
    @event.cancel!
    flash[:notice] = t("event.message.cancelled", :event_name => @event.name)
    redirect_to root_path
  end

private

  def load_event
    @event = current_user.hosted_events.find(params[:event_id] || params[:id])
  end
end
