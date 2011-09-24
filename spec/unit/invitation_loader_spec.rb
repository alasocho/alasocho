require "spec_helper"
require "invitation_loader"

describe InvitationLoader do
  let :event do
    mock(published?: true, attendances: mock())
  end

  let :invitation_params do
    { "0" => { "email" => "test1@example.com" },
      "1" => { "email" => "test2@example.com" },
      "leftovers" => "" }
  end

  let :invitation_factory do
    mock(new: mock(valid?: true, email: ""))
  end

  it "generates invitations for each valid email" do
    invitation_factory.should_receive(:new).twice
    InvitationLoader.new(event, invitation_params, invitation_factory)
  end

  it "should be valid if there are no leftovers" do
    invitation_params["leftovers"] = ""
    loader = InvitationLoader.new(event, invitation_params, invitation_factory)
    loader.should be_valid
  end

  it "shouldn't be valid if there are leftovers" do
    invitation_params["leftovers"] = "something wrong"
    loader = InvitationLoader.new(event, invitation_params, invitation_factory)
    loader.should_not be_valid
  end

  it "shouldn't be valid if any of the emails are invalid" do
    invitation_factory.new.stub!(:valid?).and_return(false)
    loader = InvitationLoader.new(event, invitation_params, invitation_factory)
    loader.should_not be_valid
  end

  it "shouldn't be valid if you don't add any invitations on a published event" do
    event.stub!(:published?).and_return(true)
    loader = InvitationLoader.new(event, { "leftovers" => "" }, invitation_factory)
    loader.should_not be_valid
  end

  it "should be valid if you don't add any invitations on an unpublished event" do
    event.stub!(:published?).and_return(false)
    loader = InvitationLoader.new(event, { "leftovers" => "" }, invitation_factory)
    loader.should be_valid
  end

  it "should not modify the invitation parameters passed" do
    expect {
      InvitationLoader.new(event, invitation_params, invitation_factory)
    }.to_not change { invitation_params }
  end
end
