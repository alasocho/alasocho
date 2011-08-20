require 'geoip'
require 'ostruct'

class GeoLocator
  def self.city_from_ip(ip)
    ActiveSupport::Deprecation.warn("GeoLocator.city_from_ip is deprecated. Use GeoLocator#location instead")
    return "Montevideo, Uruguay" if Rails.env.development?
    new(ip).location
  end

  cattr_accessor :default_source
  self.default_source = GeoIP.new(Rails.root.join("data", "GeoLiteCity.dat"))

  @@mock = OpenStruct.new(city_name: "Montevideo",
                          country_name: "Uruguay",
                          timezone: "America/Montevideo")

  def initialize(ip, source=self.class.default_source)
    @ip = ip

    if @ip == "127.0.0.1"
      @data = @@mock
    else
      @data = source.city(@ip)
    end
  end

  def city
    @data.city_name
  end

  def country
    @data.country_name
  end

  def timezone
    @data.timezone
  end

  def to_s
    [city, country].compact.join(", ")
  end
end
