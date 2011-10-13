module ALasOcho::SpecHelpers::Authentication
  def self.extended(example_group)
    example_group.fixtures :users
  end

  def sign_in(user)
    let!(:current_user) do
      user = User === user ? user : users(user)
      controller.stub!(:current_user).and_return(user)
      user
    end
  end

  def sign_out
    let!(:current_user) do
      controller.stub!(:current_user).and_return(nil)
      nil
    end
  end
end

RSpec.configure do |config|
  config.extend ALasOcho::SpecHelpers::Authentication, type: :controller
end
