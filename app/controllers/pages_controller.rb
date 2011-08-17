class PagesController < ApplicationController
  def home
    @current_city = GeoLocator.city_from_ip(request.remote_addr)
    @public_events = Event.public_events_near(@current_city).limit(4).future
    redirect_to dashboard_path if signed_in?
  end
end
