class DashboardController < ApplicationController
  before_filter :authenticate_user, :only => :dashboard

  def index
    @my_events = current_user.interests.order("start_at DESC").limit(10)
    @public_events = Event.where(:public => true).limit(15)
    @pending_invites = current_user.pending_events.where(:city => GeoLocator.city_from_ip(request.remote_addr)).order("start_at DESC").limit(5)
    render "dashboard/dashboard"
  end
end
