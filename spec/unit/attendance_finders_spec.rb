require "unit_spec_helper"
require "attendance/attendance_finders"

describe ALasOcho::AttendanceFinders do
  subject do
    Object.new.tap { |obj| obj.extend ALasOcho::AttendanceFinders }
  end

  describe "#for" do
    let :attendance_proxy do
      double(find_by_user_id: nil, new: nil)
    end

    let :event do
      double(attendances: attendance_proxy)
    end

    let :user do
      double()
    end

    let :attendance do
      double()
    end

    context "when a relationship between the event and the user exists" do
      before { attendance_proxy.stub(:find_by_user_id).and_return(attendance) }

      it "tries to find the attendance by user" do
        attendance_proxy.should_receive(:find_by_user_id).with(user).and_return(attendance)
        subject.for(event, user).should be(attendance)
      end

      it "returns the existing attendance" do
        subject.for(event, user).should be(attendance)
      end

      it "doesn't try to instantiate a new one" do
        attendance_proxy.should_not_receive(:new)
        subject.for(event, user)
      end
    end

    context "when a relationship between the event and the user doesn't exist yet" do
      before { attendance_proxy.stub(:new).and_return(attendance) }

      it "the instantiated attendance is in an invited state" do
        attendance_proxy.should_receive(:new).with(hash_including(state: "invited"))
        subject.for(event, user)
      end

      it "the instantiated attendance is linked to the user" do
        attendance_proxy.should_receive(:new).with(hash_including(user_id: user))
        subject.for(event, user)
      end

      it "returns the new attendance" do
        subject.for(event, user).should be(attendance)
      end
    end
  end
end
