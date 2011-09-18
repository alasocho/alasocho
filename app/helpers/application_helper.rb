# -*- encoding: utf-8 -*-

module ApplicationHelper
  def current_locale
    I18n.locale
  end

  def flash_messages
    { :notice => :success, :alert => :warning }.detect do |key, type|
      return render("layouts/flash_message", text: flash[key], type: type) if flash[key]
    end
  end

  def close_button
    link_to "×", "javascript:;", class: "close"
  end

  def see_all_link(url, label=t("shared.see_all"))
    link_to label, url, class: "see_all"
  end
end
