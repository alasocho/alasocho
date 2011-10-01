require "unit_spec_helper"
require "user/event_organizing"

describe ALasOcho::EventOrganizing do
  class FakeUser
    include ALasOcho::EventOrganizing

    def email
      "some.email@example.com"
    end
  end

  describe "#host_event" do
    subject { FakeUser.new }

    let :attendance_builder do
      double(:host= => nil)
    end

    let :event do
      double(:host= => subject, attendances: attendance_builder)
    end

    context "with a successful save" do
      before { event.stub!(:save).and_return(true) }

      it "returns the event" do
        result = subject.host_event(event)
        result.should be(event)
      end

      it "links the user to the event through an attendance" do
        attendance_builder.should_receive(:host=).with(subject)
        subject.host_event(event)
      end
    end

    context "with a failed save" do
      before { event.stub!(:save).and_return(false) }

      it "returns the event" do
        result = subject.host_event(event)
        result.should be(event)
      end
    end
  end
end
