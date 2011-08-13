class DashboardController < ApplicationController
  before_filter :authenticate_user, :only => :dashboard

  def index
    @my_events = current_user.interests.order("start_at DESC").limit(10)
    @public_events = Event.where(:public => true).limit(15)
    render "dashboard/dashboard"
  end
end
