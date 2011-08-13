module ApplicationHelper
  def current_locale
    I18n.locale
  end

  def flash_messages
    [:notice, :alert].detect do |key|
      if flash[key]
        message = content_tag(:div, flash[key], id: "flash-#{key}")
        return content_tag(:section, message.html_safe, id: "flash")
      end
    end
  end
end
