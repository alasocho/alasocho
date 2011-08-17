class DashboardsController < ApplicationController
  before_filter :authenticate_user, :only => :dashboard

  def show
    @page_title = t("dashboard.title")

    @my_events = current_user.interests.future.order("start_at DESC").limit(10)
    @current_city = GeoLocator.city_from_ip(request.remote_addr)
    @public_events = Event.public_events_near(@current_city).limit(5).future
    @pending_invites = current_user.pending_attendances.joins(:event).order("events.start_at DESC").limit(5)
  end
end
