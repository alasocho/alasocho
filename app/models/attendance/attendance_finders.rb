module ALasOcho::AttendanceFinders
  def for(event, user)
    event.attendances.find_by_user_id(user.to_param) ||
      event.attendances.new(user_id: user.to_param, state: "invited")
  end
end
