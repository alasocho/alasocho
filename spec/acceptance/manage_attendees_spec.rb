# -*- encoding: utf-8 -*-
# FIXME: We should move the '×' strings into the locale file.
require "acceptance_spec_helper"

Capybara.add_selector :guest_row do
  xpath { |user| XPath.css("#management li:contains('#{user.name}')") }
end

describe "The host managing the event guests" do
  fixtures :all

  it "can force-approve a user", :js do
    sign_in :event_host

    visit event_path(events(:board_games_night))
    click_link t("events.manage_attendees.link")

    within :guest_row, users(:declined_user) do
      click_link t("event.host_actions.confirm", count: 1)
    end
    click_link "×"

    # FIXME: this should be automatic (ie: the javascript should pick up the
    # changes without needing a page reload)
    reload

    page.should have_no_selector("#declined")

    within "#guests .confirmed" do
      page.should have_content(users(:declined_user).name)
    end
  end

  it "can force-reject a user", :js do
    sign_in :event_host

    visit event_path(events(:board_games_night))
    click_link t("events.manage_attendees.link")

    within :guest_row, users(:confirmed_user) do
      click_link t("event.host_actions.decline")
    end
    click_link "×"

    # FIXME: this should be automatic (ie: the javascript should pick up the
    # changes without needing a page reload)
    reload

    within "#guests .confirmed" do
      page.should have_no_content(users(:confirmed_user).name)
    end

    within("#declined") do
      click_link t("guests.declined.see_list")
    end

    within ".modal" do
      page.should have_content(users(:confirmed_user).name)
    end
  end
end
