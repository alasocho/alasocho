require 'rails_spec_helper'

describe "Waitlisting process" do
  fixtures :events, :attendances, :users

  let(:event) { events(:forever_alone) }
  let(:attendance) { attendances(:forever_alone_invitation) }

  context "when waitlisting" do
    before do
      now = Time.now
      Time.stub!(:now).and_return(now)
      attendance.waitlist!
    end

    it "sets the waitlisted_at field" do
      attendance.waitlisted_at.should be_present
      attendance.waitlisted_at.should == Time.now
    end
  end
end
