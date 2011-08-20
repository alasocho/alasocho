class PagesController < ApplicationController
  def home
    @public_events = Event.public_events_near(current_location.to_s).limit(4).future
    redirect_to dashboard_path if signed_in?
  end
end
