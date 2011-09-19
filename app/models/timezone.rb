require "tzinfo"

class Timezone < Struct.new(:source, :name, :code, :offset)
  def self.get(name)
    return Unidentified.new if name.nil?

    tz = TZInfo::Timezone.get(name)
    new(
      tz,
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

  def to_json
    { name: name, code: code, offset: offset }.to_json
  end

  class Unidentified < Timezone
    def initialize
      self.name = nil
      self.code = nil
      self.source = nil
      self.offset = 0
    end
  end
end
