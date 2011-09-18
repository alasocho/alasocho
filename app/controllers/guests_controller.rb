require "event_finders"

class GuestsController < ApplicationController
  include EventFinders

  def confirmed
    load_event
    @attendances = @event.confirmed_invitations
    render :list
  end

  def invited
    load_event
    @attendances = @event.pending_invitations.uniq
    render :list
  end

  def waitlisted
    load_event
    @attendances = @event.waitlisted_invitations
    render :list
  end

  def declined
    load_event
    @attendances = @event.declined_invitations
    render :list
  end

  def manage
    load_own_event
    @page_title = @event.name
    @attendances = @event.attendances.includes(:event, :user)
  end
end
