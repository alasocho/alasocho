class DashboardController < ApplicationController
  before_filter :authenticate_user, :only => :dashboard

  def index
    @my_events = current_user.interests.order("start_at DESC").limit(10)
    @current_city = GeoLocator.city_from_ip(request.remote_addr)
    @public_events = Event.where(:public => true, :city => @current_city).limit(15)
    @pending_invites = current_user.pending_events.order("start_at DESC").limit(5)
    render "dashboard/dashboard"
  end
end
