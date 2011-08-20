require 'geoip'
require 'ostruct'

class Location
  cattr_accessor :default_source
  self.default_source = GeoIP.new(Rails.root.join("data", "GeoLiteCity.dat"))

  @@mock = OpenStruct.new(city_name: "Montevideo",
                          country_name: "Uruguay",
                          timezone: "America/Montevideo")

  def self.from_ip(ip, source=self.default_source)
    if ip == "127.0.0.1"
      new @@mock
    else
      new source.city(@ip)
    end
  end

  def initialize(data)
    @data = data
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
