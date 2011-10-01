module ALasOcho::SpecHelpers::Events
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
      fill_in label.t(:name),        with: attrs.fetch(:name)
      fill_in label.t(:description), with: attrs.fetch(:description)
      fill_in "event[start_at]",     with: attrs.fetch(:start_at).to_s(:iso)
      fill_in "event[end_at]",       with: attrs.fetch(:end_at).to_s(:iso)
      fill_in label.t(:location),    with: attrs.fetch(:location)
      fill_in label.t(:city),        with: attrs.fetch(:city)
    end

    click_button t("helpers.submit.create", model: t("activerecord.models.event"))
  end
end

RSpec.configure do |config|
  config.include ALasOcho::SpecHelpers::Events
end
