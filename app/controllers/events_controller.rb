require "event_finders"

class EventsController < ApplicationController
  include EventFinders

  before_filter :check_token, :only => [:show]
  before_filter :authenticate_user, :except => [:show, :confirmed, :invited, :waitlisted]

  MAX_CONFIRMED_ATTENDEES = 10
  MAX_WAITLISTED_ATTENDEES = 5
  MAX_PENDING_ATTENDEES = 5

  def index
    @events = current_user.events_timeline.order("start_at DESC")
  end

  def show
    load_event

    @page_title       = @event.name
    @page_description = @event.description

    @attendance             = signed_in? ? @event.attendance_for(current_user).tap { |a| a.touch(:updated_at) unless a.new_record? } : nil
    @comments               = @event.comments
    @confirmed_invitations  = @event.confirmed_invitations.includes(:user).limit(MAX_CONFIRMED_ATTENDEES)
    @waitlisted_invitations = @event.waitlisted_invitations.includes(:user).limit(MAX_WAITLISTED_ATTENDEES)
    @pending_invitations    = @event.pending_invitations.includes(:user).limit(MAX_PENDING_ATTENDEES)

    if @event.viewable?
      respond_to do |format|
        format.html
        format.ics { render text: @event.to_ical }
      end
    else
      redirect_to event_invite_people_path(@event)
    end
  end

  def new
    @event = current_user.hosted_events.new(:city => current_location.to_s)
  end

  def create
    @event = current_user.hosted_events.new(params[:event])

    if @event.save
      flash[:notice] = t("event.form.create.message.success")
      @event.attendances.create!(email: current_user.email, state: "confirmed", user: current_user)
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

  def invite
    load_event_writable
    @page_title = @event.name
    if @event.allow_invites_from(current_user)
      list = JSON params[:invitees]
      @event.invitee_list = list
      @event.save
      respond_to do |format|
        format.json { render :json => "OK"}
      end
    end
  end

  def my_events
    @page_title = t("my_events.title")
    @my_events = current_user.hosted_events
  end

  def everyone
    load_own_event
    @page_title = @event.name
    @attendances = @event.attendances.includes(:event, :user)
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

  def confirmed
    load_event
    @attendances =  @event.confirmed_invitations
  end

  def invited
    load_event
    @attendances = @event.pending_invitations.uniq
  end

  def waitlisted
    load_event
    @attendances = @event.waitlisted_invitations
  end

  def declined
    load_event
    @attendances = @event.declined_invitations
  end

  private

  def check_token
    if params[:token].present?
      session[:attendance_id] = Attendance.find_by_token(params[:token]).try(:id)
    end
  end
end
