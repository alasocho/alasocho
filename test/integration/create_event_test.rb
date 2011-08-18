require 'integration_test_helper'

class CreateEventTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "create an event and publish it" do
    sign_in :event_host

    click_link t("events.form.button.new")
    create_event name: "My Event", end_at: 3.hours.from_now
    click_button t("event.form.invite.submit") # FIXME: Use a better label

    event = Event.find_by_name("My Event")
    assert_equal "published", event.state
    assert event.end_at.present?
  end
end
