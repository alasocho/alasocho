RSpec::Matchers.define :be_attending do |event|
  match do |user|
    attendance = Attendance.for(event, user)
    attendance.confirmed?
  end

  failure_message_for_should do |user|
    attendance = Attendance.for(event, user)
    "expected that #{user} attended #{event}, but the attendance is '#{attendance.state}'"
  end
end

RSpec::Matchers.define :be_waitlisted_for do |event|
  match do |user|
    attendance = Attendance.for(event, user)
    attendance.waitlisted?
  end

  failure_message_for_should do |user|
    attendance = Attendance.for(event, user)
    "expected that #{user} was in #{event}'s waitlist, but the attendance is '#{attendance.state}'"
  end
end
