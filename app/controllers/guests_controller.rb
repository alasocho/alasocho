require "event_finders"

class GuestsController < ApplicationController
  include EventFinders

  def confirmed
    load_event
    @attendances = @event.attendances.confirmed.includes(:user)
    render :list
  end

  def invited
    load_event
    @attendances = @event.attendances.pending.includes(:user)
    render :list
  end

  def waitlisted
    load_event
    @attendances = @event.attendances.waitlisted.includes(:user)
    render :list
  end

  def declined
    load_event
    @attendances = @event.attendances.declined.includes(:user)
    render :list
  end

  def manage
    load_own_event
    @page_title = @event.name
    @attendances = @event.attendances.includes(:event, :user)
  end
end
