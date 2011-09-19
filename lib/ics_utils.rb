module IcsUtils
  def self.to_ics(event)
    url = url_helpers.event_url(event, host: ALasOcho.config[:canonical_host])

    RiCal.Event do
      summary     event.name
      url         url
      description event.description
      dtstart     event.start_at
      dtend       event.end_at_with_default
      location    event.full_address
    end.export
  end

  def self.url_helpers
    Rails.application.routes.url_helpers
  end
  private_class_method :url_helpers
end
