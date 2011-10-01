require "unit_spec_helper"
require "ostruct"
require "attendance/event_proxy_extensions"

describe ALasOcho::EventProxyExtensions do
  subject do
    proxy = Object.new
    proxy.extend ALasOcho::EventProxyExtensions
    proxy
  end

  let :user do
    double(email: "foo@example.com")
  end

  describe "#host=" do
    it "instantiates a new attendance with an email" do
      subject.should_receive(:new).with(hash_including(email: "foo@example.com"))
      subject.host = user
    end

    it "sets the attendance's user" do
      subject.should_receive(:new).with(hash_including(user: user))
      subject.host = user
    end

    it "sets the attendance's state to 'confirmed'" do
      subject.should_receive(:new).with(hash_including(state: "confirmed"))
      subject.host = user
    end
  end
end
