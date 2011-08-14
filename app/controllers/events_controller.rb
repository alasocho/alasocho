class EventsController < ApplicationController
  before_filter :check_token, :only => [:show]
  before_filter :authenticate_user, :except => [:show, :confirmed, :invited, :waitlisted]

  def new
    @event = current_user.hosted_events.new(:city => GeoLocator.city_from_ip(request.remote_addr))
  end

  def create
    @event = current_user.hosted_events.new(params[:event])

    if @event.save
      flash[:notice] = t("event.form.create.message.success")
      @event.attendances.create!(:email => current_user.email, :state => "confirmed") do |attendance|
        attendance.user = current_user
      end
      redirect_to event_invite_people_path(@event)
    else
      render :action => :new
    end
  end

  def edit
    load_own_event
  end

  def invite
    load_event_writable
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
    @my_events = current_user.hosted_events
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
      render :action => :invite_people
    end
  end

  MAX_CONFIRMED_ATTENDEES = 8
  MAX_WAITLISTED_ATTENDEES = 4
  MAX_PENDING_ATTENDEES = 4

  def show
    load_event
    @attendance             = @event.attendance_for(current_user).tap { |a| a.touch(:updated_at) unless a.new_record? }
    @comments               = @event.comments
    @confirmed_invitations  = @event.confirmed_invitations.includes(:user).limit(MAX_CONFIRMED_ATTENDEES)
    @waitlisted_invitations = @event.waitlisted_invitations.includes(:user).limit(MAX_WAITLISTED_ATTENDEES)
    @invited_invitations    = @event.pending_invitations.includes(:user).limit(MAX_PENDING_ATTENDEES)
  end

  def public
    current_city = GeoLocator.city_from_ip(request.remote_addr)
    @events = Event.public_events_near(current_city)
  end

  def destroy
    load_own_event
    @event.cancel!
    flash[:notice] = t("event.message.cancelled", :event_name => @event.name)
    redirect_to root_path
  end

  def index
    @events = current_user.events_timeline.order("start_at DESC")
  end

  def confirmed
    load_event
    @attendances =  @event.confirmed_invitations
  end

  def invited
    load_event
    @attendances = @event.pending_invitations
  end

  def waitlisted
    load_event
    @attendances = @event.waitlisted_invitations
  end

private

  def load_own_event
    @event = current_user.hosted_events.find(params[:event_id] || params[:id])
  end

  def load_event
    @event = (signed_in? ? Event.viewable_by(current_user) : Event.public_events).find(params[:event_id] || params[:id])
  end

  def load_event_writable
    load_event
    @event = Event.find(@event.id)
  end

  def check_token
    if params[:token].present?
      session[:attendance_id] = Attendance.find_by_token(params[:token]).try(:id)
    end
  end

end
