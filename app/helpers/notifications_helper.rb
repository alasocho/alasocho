module NotificationsHelper
  def user_notifications
    @_user_notifications ||= Notification.all(current_user)
  end

  def notifications_menu_link
    link_to content_tag(:span, user_notifications.size).html_safe,
      "javascript:;",
      class: ["menu", user_notifications.any? ? "has_notifications" : "no_notifications"]
  end
end
