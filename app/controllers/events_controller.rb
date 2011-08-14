class EventsController < ApplicationController
  before_filter :check_token, :only => [:show]
  before_filter :authenticate_user, :except => [:show, :confirmed, :invited, :waitlisted]

  def new
    @event = current_user.hosted_events.new(:city => GeoLocator.city_from_ip(request.remote_addr))
  end

  def cleanup_date(hash)
    return nil if hash.blank?
    if hash[:date].present? && hash[:time].present?
      Time.parse("#{hash[:date]} #{hash[:time]} UTC +00:00")
    else
      nil
    end
  end

  def create
    # TODO nasty workaround
    data = params[:event]
    data[:start_at] = cleanup_date data[:start_at]
    data[:end_at] = cleanup_date data[:end_at]
    @event = current_user.hosted_events.new(data)

    if @event.save
      flash[:notice] = t("event.form.create.message.success")
      @event.attendances.create!(email: current_user.email, state: "confirmed", user: current_user)
      redirect_to event_invite_people_path(@event)
    else
      render :action => :new
    end
  end

  def edit
    load_own_event
    @page_title = @event.name
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

  def invite_people
    load_own_event
    @page_title = @event.name
  end

  def update
    load_own_event
    # TODO OMG fix this, my brain stop responding!
    data = params[:event]
    start_at = cleanup_date data[:start_at]
    end_at = cleanup_date data[:end_at]
    if start_at then data[:start_at] = start_at else data.delete(:start_at) end
    data[:end_at] = end_at

    @event.attributes = data

    date_changed = @event.start_at_changed? || @event.end_at_changed?

    if @event.save
      @event.publish!

      NotifyDateChange.enqueue(@event.id) if date_changed
      flash[:notice] = t("event.form.invite.message.success")

      redirect_to @event
    else
      flash[:alert] = t("event.form.invite.message.error")
      render :action => :invite_people
    end
  end

  MAX_CONFIRMED_ATTENDEES = 10
  MAX_WAITLISTED_ATTENDEES = 5
  MAX_PENDING_ATTENDEES = 5

  def show
    load_event

    @page_title       = @event.name
    @page_description = @event.description

    @attendance             = signed_in? ? @event.attendance_for(current_user).tap { |a| a.touch(:updated_at) unless a.new_record? } : nil
    @comments               = @event.comments
    @confirmed_invitations  = @event.confirmed_invitations.includes(:user).limit(MAX_CONFIRMED_ATTENDEES)
    @waitlisted_invitations = @event.waitlisted_invitations.includes(:user).limit(MAX_WAITLISTED_ATTENDEES)
    @pending_invitations    = @event.pending_invitations.includes(:user).limit(MAX_PENDING_ATTENDEES)

    respond_to do |format|
      format.html
      format.ics { render text: @event.to_ical }
    end
  end

  def public
    @page_title = t("events.public.title")
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

  def load_own_event
    @event = current_user.hosted_events.find(params[:event_id] || params[:id])
  end

  def load_event
    id, token = (params[:event_id] || params[:id]).split('-')
    @event = (signed_in? ? Event.viewable_by(current_user, token) : Event.public_events(token)).find(id)
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
