require "test_helper"

class NotificationTestCase < ActiveSupport::TestCase
  test "the constructor decides when it's an invitation" do
    attendance = Attendance.new
    def attendance.need_action?() true end

    notification = Notification.new(attendance)
    assert_kind_of Notification::Invitation, notification
  end

  test "the constructor decides when it's a comment" do
    attendance = Attendance.new
    def attendance.need_action?() false end

    notification = Notification.new(attendance)
    assert_kind_of Notification::Comment, notification
  end
end

class InvitationNotificationTestCase < ActiveSupport::TestCase
  setup do
    @notification = Notification::Invitation.new(
      attendances(:board_games_night_invitation)
    )
    @event = events(:board_games_night)
  end

  test "its #object is the event" do
    assert_equal @event, @notification.object
  end

  test "it delegates its name to the event" do
    assert_equal @event.name, @notification.name
  end

  test "it delegates its location to the event" do
    assert_equal @event.location, @notification.location
  end

  test "it delegates whether it has a guest limit or not to the event" do
    assert_equal @event.limited?, @notification.limited?
  end

  test "it delegates the total amount of slots to the event" do
    assert_equal @event.attendee_quota, @notification.quota
  end

  test "it delegates the number of available slots to the event" do
    assert_equal @event.available_slots, @notification.available_slots
  end

  test "it delegates the starting time to the event" do
    assert_equal @event.start_at, @notification.time
  end
end

class CommentNotificationTestCase < ActiveSupport::TestCase
  setup do
    @notification = Notification::Comment.new(
      attendances(:board_games_night_host)
    )
    @event = events(:board_games_night)
  end

  test "its #object is the event" do
    assert_equal @event, @notification.object
  end

  test "it delegates its name to the event" do
    assert_equal @event.name, @notification.name
  end
end
