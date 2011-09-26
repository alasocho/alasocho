class DashboardsController < ApplicationController
  before_filter :authenticate_user

  def show
    @page_title = t("dashboard.title")

    @my_events = current_user.interests.future.order("start_at ASC").limit(10)
    @public_events = Event.public_events_near(current_location.to_s).limit(5).future
    @pending_invites = current_user.pending_attendances.joins(:event).order("events.start_at DESC").limit(5)
  end
end
