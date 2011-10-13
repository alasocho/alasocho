require "rails_spec_helper"

describe "User organizes an event" do
  it "can organize an event by filling the event form" do
    sign_in :event_host

    click_link t("events.form.button.new")
    create_event name: "My Event"
    click_button t("event.form.invite.submit") # FIXME: Use a better label

    event = Event.find_by_name("My Event")

    event.state.should == "published"
    event.start_at.should be_present
  end

  it "can invite people when organizing an event", :js do
    sign_in :event_host

    click_link t("events.form.button.new")
    create_event name: "My Event"

    fill_in t("events.invitation_box.label"), with: "invitee1@example.com, invitee2@example.com"
    click_button t("event.form.invite.submit") # FIXME: Use a better label

    within "#guests .pending" do
      page.should have_content(t("guests.invited", count: 2))
      page.should have_content("invitee1")
      page.should have_content("invitee2")
    end
  end
end
