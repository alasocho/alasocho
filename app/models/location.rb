require "geo_ip"

class Location
  def self.from_ip(ip, locator=GeoIp.new)
    new(locator.locate(ip))
  end

  attr :source

  delegate :city, :country, to: :source

  def initialize(source)
    @source = source
  end

  def city_and_country
    [city, country].compact.join(", ")
  end

  alias_method :to_s, :city_and_country

  def timezone
    @timezone ||= Timezone.get(source.timezone)
  end

  def inspect
    "#<Location: #{self.to_s}>"
  end
end
