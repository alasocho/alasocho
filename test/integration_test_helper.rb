require "test_helper"
require "capybara/rails"

OmniAuth.configure do |config|
  config.test_mode = true
  config.add_mock(:google, uid: "john.doe@google.com")
end

class ActionDispatch::IntegrationTest
  include Capybara

  def sign_in(user)
    user = User === user ? user : users(user)
    auth = user.authorizations.first
    visit "/auth/#{auth.provider}"
  end

  def sign_out
    visit "/auth/sign_out"
  end

  # Fill in and submit the first step of creating an event.
  def create_event(attrs={})
    attrs.reverse_merge!(
      name: "The Event",
      description: "The Description",
      start_at: 2.hours.from_now,
      end_at: 3.hours.from_now,
      location: "The Location",
      city: "Montevideo, Uruguay"
    )

    with_options scope: "activerecord.attributes.event" do |label|
      fill_in label.t(:name),          with: attrs.fetch(:name)
      fill_in label.t(:description),   with: attrs.fetch(:description)
      fill_in "event[start_at][date]", with: attrs.fetch(:start_at).strftime("%Y-%m-%d")
      fill_in "event[start_at][time]", with: attrs.fetch(:start_at).strftime("%H-%M")
      fill_in "event[end_at][date]",   with: attrs.fetch(:end_at).strftime("%Y-%m-%d")
      fill_in "event[end_at][time]",   with: attrs.fetch(:end_at).strftime("%H-%M")
      fill_in label.t(:location),      with: attrs.fetch(:location)
      fill_in label.t(:city),          with: attrs.fetch(:city)
    end

    click_button t("helpers.submit.create", model: t("activerecord.models.event"))
  end

  def t(key, options={})
    I18n.t(key, options)
  end
end
