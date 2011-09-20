require "open-uri"
require "ostruct"

class GeoIp
  cattr_accessor :endpoint
  self.endpoint = "http://geoip-service.herokuapp.com/"

  def initialize(endpoint=self.class.endpoint, logger=Rails.logger)
    @endpoint = endpoint
    @logger = logger
  end

  def locate(ip)
    if ip == "127.0.0.1"
      @logger.info "=> Requesting geolocation from localhost. Mocked response."
      return MockLocation
    end

    url = "#{@endpoint}#{ip}"
    @logger.info "=> Requesting geolocation from #{ip} at: #{url}"

    response = open(url).read
    attributes = ActiveSupport::JSON.decode(response)
    OpenStruct.new(attributes)
  end

  MockLocation = OpenStruct.new(
    city: "Montevideo", country: "Uruguay", timezone: "America/Montevideo"
  )
end
