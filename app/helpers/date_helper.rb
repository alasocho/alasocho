module DateHelper
  def calendar_l10n_settings
    return if I18n.locale.to_s.starts_with?("en")
    :"jquery.ui.datepicker-#{I18n.locale}"
  end

  def time_select(name_prefix)
    time = lambda do |hours, minutes|
      am = (hours / 12).zero?
      showable_hours = (hours % 12).zero? ? 12 : (hours % 12)

      ["#{"%02d" % (showable_hours)}:#{"%02d" % minutes} #{am ? "am" : "pm"}",
       "#{"%02d" % hours}:#{"%02d" % minutes}"]
    end

    options = (0..23).map { |hour| [time[hour, 0], time[hour, 30]] }.flatten(1)

    select_tag "#{name_prefix}_time", options_for_select(options), name: ""
  end

  def js_date_format
    t("date.formats.default").gsub(/%(.)/, '\1\1').downcase
  end
end
