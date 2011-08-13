class NotifyDateChange < Job
  @queue = :normal

  def perform(event_id)
    Event.find(event_id).interested_invitations.each do |interested_invitation|
      AttendanceMailer.date_change_notification(interested_invitation).deliver
    end
  end
end
