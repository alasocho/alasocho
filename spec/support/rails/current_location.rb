module ALasOcho::SpecHelpers::CurrentLocation
  def set_incoming_request_ip(ip="127.0.0.1")
    before { request.env["HTTP_X_FORWARDED_FOR"] = ip }

    let(:current_location) do
      Location.from_ip(ip)
    end
  end
end

RSpec.configure do |config|
  config.extend ALasOcho::SpecHelpers::CurrentLocation, type: :controller
end
