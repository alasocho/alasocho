require "acceptance_spec_helper"

describe "User organizes an event" do
  it "can organize an event by filling the event form" do
    sign_in :event_host

    click_link t("events.form.button.new")
    create_event name: "My Event", end_at: 3.hours.from_now
    click_button t("event.form.invite.submit") # FIXME: Use a better label

    event = Event.find_by_name("My Event")

    event.state.should == "published"
    event.start_at.should be_present
  end
end
