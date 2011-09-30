require "functional_spec_helper"

describe "Inviting users to an event" do
  fixtures :events, :attendances, :users

  let :invitation_params do
    { "0" => { "email" => users(:uninvited_user_1).email },
      "1" => { "email" => users(:uninvited_user_2).email },
      "leftovers" => "" }
  end

  let :event do
    events(:board_games_night)
  end

  it "creates an attendance for each provided email" do
    InvitationLoader.new(event, invitation_params)
    expect { event.save }.to change { event.attendances.count }.by(2)
  end

  it "is invalid if you try to invite someone who's already on the event" do
    invitation_params["2"] = { "email" => users(:invited_user).email }
    loader = InvitationLoader.new(event, invitation_params)
    loader.should_not be_valid
  end

  it "is invalid if you provide an invalid looking email" do
    invitation_params["0"]["email"] = "this is not valid"
    loader = InvitationLoader.new(event, invitation_params)
    loader.should_not be_valid
  end
end
