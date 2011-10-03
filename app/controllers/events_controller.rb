require "event_finders"
require "ics_utils"

class EventsController < ApplicationController
  include EventFinders

  before_filter :check_token, :only => [:show]
  before_filter :authenticate_user, :except => [:show, :public]

  MAX_CONFIRMED_ATTENDEES = 12
  MAX_WAITLISTED_ATTENDEES = 6
  MAX_PENDING_ATTENDEES = 6

  def index
    @events = current_user.events_timeline.order("start_at DESC")
  end

  def show
    load_event

    if @event.viewable?
      @page_title       = @event.name
      @page_description = @event.description

      @rsvp                   = Rsvp.new(Attendance.for(@event, current_user))
      @comments               = @event.comments.includes(:user)
      @confirmed_invitations  = @event.attendances.confirmed.includes(:user).limit(MAX_CONFIRMED_ATTENDEES)
      @waitlisted_invitations = @event.attendances.waitlisted.includes(:user).limit(MAX_WAITLISTED_ATTENDEES)
      @pending_invitations    = @event.attendances.pending.includes(:user).limit(MAX_PENDING_ATTENDEES)

      # TODO: This should be refactored into something prettier :)
      Attendance.for(@event, current_user).touch(:updated_at) if @rsvp.replied?

      respond_to do |format|
        format.html
        format.ics { render text: IcsUtils.to_ics(@event) }
      end
    else
      respond_to do |format|
        format.html { redirect_to event_invite_people_path(@event) }
        format.ics  { render nothing: true, status: :forbidden }
      end
    end
  end

  def new
    @event = Event.organize_at(current_location)
  end

  def create
    @event = current_user.host_event(Event.new(params[:event]))

    if @event.persisted?
      flash[:notice] = t("event.form.create.message.success")
      redirect_to event_invite_people_path(@event)
    else
      render :action => :new
    end
  end

  def invite_people
    load_own_event
    @invitations = InvitationLoader.new(@event, {})
    @page_title = @event.name
  end

  def edit
    load_own_event
    @page_title = @event.name
  end

  def publish
    load_own_event

    @event.attributes = params[:event]
    @invitations = InvitationLoader.new(@event, params[:invitations])

    if @invitations.valid? && @event.save
      @event.publish!
      redirect_to @event, notice: t("event.form.invite.message.success")
    else
      render :invite_people
    end
  end

  def update
    load_own_event

    @event.attributes = params[:event]
    date_changed = @event.start_at_changed? || @event.end_at_changed?

    if @event.save
      NotifyDateChange.enqueue(@event.id) if date_changed
      redirect_to @event, notice: t("event.form.invite.message.success")
    else
      render :edit
    end
  end

  def my_events
    @page_title = t("my_events.title")
    @my_events = current_user.hosted_events
  end

  def public
    @page_title = t("events.public.title")
    @events = Event.public_events_near(current_location.to_s).future
  end

  def destroy
    load_own_event
    @event.cancel!
    flash[:notice] = t("event.message.cancelled", :event_name => @event.name)
    redirect_to root_path
  end

  private

  def check_token
    if params[:token].present?
      session[:attendance_id] = Attendance.find_by_token(params[:token]).try(:id)
    end
  end
end
