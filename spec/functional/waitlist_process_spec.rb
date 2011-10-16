require 'rails_spec_helper'

describe "Waitlisting process" do
  fixtures :events, :attendances, :users

  let(:event) { events(:forever_alone) }
  let(:attendance) { attendances(:forever_alone_invitation) }

  context "when waitlisting" do
    it "sets the waitlisted_at field" do
      now = Time.now
      Time.stub!(:now).and_return(now)
      attendance.waitlist!
      attendance.waitlisted_at.should be_present
      attendance.waitlisted_at.should == Time.now
    end

    it "orders the waitlisted attendances by waitlisted_at time" do
      attendances(:forever_alone_invitation).waitlist!
      event.attendances.waitlisted.first.should == attendances(:forever_alone_in_waitlist)
      event.attendances.waitlisted.last.should  == attendances(:forever_alone_invitation)
    end
  end
end
