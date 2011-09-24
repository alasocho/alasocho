require "spec_helper"
require "invitation"

describe Invitation do
  let :email do
    "test@test.com"
  end

  let :attendance_factory do
    mock(new: attendance)
  end

  context "when generating a valid attendance" do
    let :attendance do
      mock(valid?: true)
    end

    it "is valid" do
      invitation = Invitation.new(attendance_factory, email)
      invitation.should be_valid
    end
  end

  context "when generating an invalid attendance" do
    let :attendance do
      mock(valid?: false)
    end

    it "is invalid" do
      invitation = Invitation.new(attendance_factory, email)
      invitation.should_not be_valid
    end
  end
end
