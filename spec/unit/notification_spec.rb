require "spec_helper"
require "notification"

describe Notification do
  describe ".all" do
    let :finder do
      [mock(need_action?: true), mock(need_action?: false)]
    end

    let :user do
      mock()
    end

    it "returns a list of notifications" do
      notifications = described_class.all(user, finder)
      notifications.all? { |n| n.should be_kind_of(Notification::Base) }
    end
  end

  describe ".new" do
    it "decides when it's an invitation" do
      attendance = mock(need_action?: true)
      notification = Notification.new(attendance)
      notification.should be_kind_of Notification::Invitation
    end

    it "decides when it's a new comment" do
      attendance = mock(need_action?: false)
      notification = Notification.new(attendance)
      notification.should be_kind_of Notification::Comment
    end
  end

  let :event do
    mock(name:            "The Name",
         location:        "The Location",
         limited?:        true,
         attendee_quota:  5,
         available_slots: 3,
         start_at:        Time.now)
  end

  let :attendance do
    mock(event: event)
  end

  describe Notification::Invitation do
    subject { Notification::Invitation.new(attendance) }

    its(:attendance)      { should == attendance }
    its(:object)          { should == event }
    its(:name)            { should == event.name }
    its(:location)        { should == event.location }
    its(:limited?)        { should == event.limited? }
    its(:quota)           { should == event.attendee_quota }
    its(:available_slots) { should == event.available_slots }
    its(:time)            { should == event.start_at }
  end

  describe Notification::Comment do
    subject { Notification::Comment.new(attendance) }

    its(:attendance) { should == attendance }
    its(:object)     { should == event }
    its(:name)       { should == event.name }
  end
end
