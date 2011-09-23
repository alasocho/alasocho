class NotifyDateChange < Job
  @queue = :normal

  def perform(event_id)
    Event.find(event_id).attendances.interested.each do |interested_invitation|
      AttendanceMailer.date_change_notification(interested_invitation).deliver
    end
  end
end
