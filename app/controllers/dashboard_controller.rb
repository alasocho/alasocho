class DashboardController < ApplicationController
  before_filter :authenticate_user, :only => :dashboard

  def index
    @page_title = t("dashboard.title")

    @my_events = current_user.interests.order("start_at DESC").limit(10)
    @current_city = GeoLocator.city_from_ip(request.remote_addr)
    @public_events = Event.public_events_near(@current_city).limit(15)
    @pending_invites = current_user.pending_attendances.joins(:event).order("events.start_at DESC").limit(5)
    render "dashboard/dashboard"
  end
end
