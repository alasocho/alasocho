require "tzinfo"

class Timezone < Struct.new(:identifier, :name, :code, :offset)
  def self.get(name)
    return Unidentified.new if name.nil?

    tz = TZInfo::Timezone.get(name)
    new(
      tz.name,
      tz.friendly_identifier,
      tz.current_period.abbreviation,
      tz.current_period.utc_total_offset / 3600
    )
  end

  def to_s
    return code if offset.zero?

    offset_string = offset < 0 ? offset.to_s : "+#{offset}"
    "#{code} (UTC#{offset_string}:00)"
  end

  def source
    @source ||= TZInfo::Timezone.get(identifier)
  end

  def to_json
    { name: name, code: code, offset: offset, identifier: identifier }.to_json
  end

  def ==(other)
    identifier == other.identifier
  end

  class Unidentified < Timezone
    def initialize
      self.name = nil
      self.code = nil
      self.identifier = nil
      self.offset = 0
    end
  end
end
