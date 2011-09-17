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

    respond_to do |format|
      if @invitations.valid?
        @event.save!

        format.html { redirect_to @event }
        format.js   { render nothing: true, status: :ok }
      else
        format.html { render :new }
        format.js   { render :new, status: :bad_request }
      end
    end
  end
end
