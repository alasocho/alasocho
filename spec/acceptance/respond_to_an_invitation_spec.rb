require "acceptance_spec_helper"

describe "Responding to an invitation" do
  fixtures :all

  it "should let me know I haven't taken action yet" do
    sign_in :invited_user
    visit event_path(events(:board_games_night))

    within "#rsvp" do
      page.should have_content(t("events.show.rsvp.havent_replied"))
    end
  end

  context "when I accept" do
    it "should let me know I accepted" do
      sign_in :invited_user

      visit event_path(events(:board_games_night))
      within "#rsvp" do
        click_link t("event.confirm", count: 1)
      end

      within "#rsvp" do
        page.should have_content(t("events.show.rsvp.confirmed"))
      end

      within "#guests .confirmed" do
        page.should have_content(current_user.name)
      end
    end
  end

  context "when I decline" do
    it "should let me know I declined" do
      sign_in :invited_user

      visit event_path(events(:board_games_night))
      within "#rsvp" do
        click_link t("event.decline")
      end

      within "#rsvp" do
        page.should have_content(t("events.show.rsvp.declined"))
      end

      within "#declined" do
        page.should have_content(t("guests.declined", count: 1))
      end
    end
  end
end
