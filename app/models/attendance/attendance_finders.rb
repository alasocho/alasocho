module ALasOcho::AttendanceFinders
  def for(event, user)
    event.attendances.find_by_user_id(user) ||
      event.attendances.new(user_id: user, state: "invited")
  end
end
