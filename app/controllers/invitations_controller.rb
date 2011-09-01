require "event_finders"

class InvitationsController < ApplicationController
  include EventFinders

  def new
    load_event
    @invitations = InvitationLoader.new(@event, {})
  end

  def create
    load_event_writable
    @invitations = InvitationLoader.new(@event, params[:invitations])

    if @invitations.valid?
      @event.save!
      redirect_to @event
    else
      render :new
    end
  end
end
