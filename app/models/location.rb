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

  def to_s
    [city, country].compact.join(", ")
  end

  def timezone
    @timezone ||= Timezone.get(source.timezone)
  end

  def inspect
    "#<Location: #{self.to_s}>"
  end
end
