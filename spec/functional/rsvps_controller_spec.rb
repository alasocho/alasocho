require "functional_spec_helper"

describe RsvpsController, type: :controller do
  fixtures :events, :attendances

  describe "#confirm" do
    set_incoming_request_ip
    sign_in :invited_user

    let :event do
      events(:board_games_night)
    end

    context "when the event has available slots" do
      it "marks the user as confirmed" do
        post :confirm, event_id: event.to_param
        current_user.should be_attending(event)
      end

      it "redirects to the event" do
        post :confirm, event_id: event.to_param
        response.should redirect_to(event_path(event))
      end

      it "adds a confirmed guest" do
        expect {
          post :confirm, event_id: event.to_param
        }.to change { event.attendances.confirmed.count }.by(1)
      end
    end

    context "when the event is full" do
      # FIXME: This goes beyond what this spec should know. We should probably
      # set up a new fixture for a "full" event.
      before { event.update_attributes(attendee_quota: 0) }

      it "marks the user as waitlisted" do
        post :confirm, event_id: event.to_param
        current_user.should be_waitlisted_for(event)
      end

      it "redirects to the event" do
        post :confirm, event_id: event.to_param
        response.should redirect_to(event_path(event))
      end

      it "adds a waitlisted guest" do
        expect {
          post :confirm, event_id: event.to_param
        }.to change { event.attendances.waitlisted.count }.by(1)
      end
    end

    context "when signed out" do
      sign_out

      it "doesn't add a confirmed guest" do
        expect {
          post :confirm, event_id: event.to_param
        }.to_not change { event.attendances.confirmed.count }
      end

      it "doesn't add a waitlisted guest" do
        expect {
          post :confirm, event_id: event.to_param
        }.to_not change { event.attendances.waitlisted.count }
      end

      it "sends you back to the event page" do
        post :confirm, event_id: event.to_param
        response.should redirect_to(event_path(event))
      end
    end
  end
end
