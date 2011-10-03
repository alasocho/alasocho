require "unit_spec_helper"
require "rsvp"

describe Rsvp do
  let :attendance do
    double("attendance", event:     event,
                         state:     nil,
                         confirm!:  nil,
                         waitlist!: nil,
                         decline!:  nil)
  end

  let :event do
    double("event")
  end

  subject do
    described_class.new(attendance)
  end

  describe "#confirm" do
    context "when the event has room for more guests" do
      before do
        event.stub!(:slots_available?).and_return(true)
        attendance.stub!(:state).and_return("confirmed")
      end

      it "confirms the attendance" do
        attendance.should_receive(:confirm!)
        subject.confirm
      end

      it "sets the status to confirmed" do
        subject.confirm
        subject.status.should == "confirmed"
      end
    end

    context "when the event is full" do
      before do
        event.stub!(:slots_available?).and_return(false)
        attendance.stub!(:state).and_return("waitlisted")
      end

      it "waitlists the attendance" do
        attendance.should_receive(:waitlist!)
        subject.confirm
      end

      it "sets the status to waitlisted" do
        subject.confirm
        subject.status.should == "waitlisted"
      end
    end
  end

  describe "#decline" do
    before do
      attendance.stub!(:state).and_return("declined")
    end

    it "declines the attendance" do
      attendance.should_receive(:decline!)
      subject.decline
    end

    it "sets the status to declined" do
      subject.decline
      subject.status.should == "declined"
    end
  end
end
