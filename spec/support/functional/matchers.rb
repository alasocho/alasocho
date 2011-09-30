RSpec::Matchers.define :be_attending do |event|
  match do |user|
    attendance = event.attendance_for(user)
    attendance.confirmed?
  end

  failure_message_for_should do |user|
    attendance = event.attendance_for(user)
    "expected that #{user} attended #{event}, but the attendance is '#{attendance.state}'"
  end
end
