require "functional_spec_helper"

describe EventsController, type: :controller do
  fixtures :users

  describe "#create" do
    let :params do
      {
        "event" => {
          "name"        => "Some Name",
          "description" => "This is some event",
          "start_at"    => 2.days.from_now.to_s(:iso),
          "end_at"      => (2.days.from_now + 1.hour).to_s(:iso),
          "location"    => "Some place",
          "city"        => "Los Angeles, United States"
        }
      }
    end

    set_incoming_request_ip
    sign_in :event_host

    context "with good parameters" do
      let(:event) { Event.last }

      it "creates an event" do
        expect { post :create, params }.to change { Event.count }.by(1)
      end

      it "redirects to the invite/publish page" do
        post :create, params
        response.should redirect_to(event_invite_people_path(event))
      end

      it "marks the host as attending" do
        post :create, params
        users(:event_host).should be_attending(event)
      end

      it "sets the event's timezone" do
        post :create, params
        event.timezone.should == current_location.timezone
      end
    end

    context "without required parameters" do
      let :failed_params do
        params["event"].delete("name")
        params
      end

      it "doesn't create an event" do
        expect { post :create, failed_params }.to_not change { Event.count }
      end

      it "renders the form again" do
        post :create, failed_params
        response.should render_template(:new)
      end
    end

    context "when signed out" do
      sign_out

      it "doesn't create an event" do
        expect { post :create, params }.to_not change { Event.count }
      end

      it "sends you back to the home page" do
        post :create, params
        response.should redirect_to(root_path)
      end

      it "sets a flash message" do
        post :create, params
      end
    end
  end
end
