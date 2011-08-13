class PagesController < ApplicationController
  def home
    @my_events = current_user.interests.order("start_at DESC").limit(10)
  end
end
