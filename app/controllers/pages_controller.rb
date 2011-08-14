class PagesController < ApplicationController
  def home
    @public_events = Event.public_events.limit(10)
    redirect_to user_root_path if signed_in?
  end
end
