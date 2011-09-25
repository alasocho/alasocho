require "unit_spec_helper"
require "timezone"
require "json"

describe Timezone do
  subject { Timezone.get("America/New_York") }

  its(:identifier) { should == "America/New_York" }
  its(:name)       { should == "America - New York" }
  its(:code)       { should == :EDT }
  its(:offset)     { should == -4 }

  describe "#to_json" do
    let :json_attributes do
      JSON.parse(subject.to_json)
    end

    it "contains the name" do
      json_attributes["name"].should == subject.name.to_s
    end

    it "contains the code" do
      json_attributes["code"].should == subject.code.to_s
    end

    it "contains the offset" do
      json_attributes["offset"].should == subject.offset.to_i
    end

    it "contains the identier" do
      json_attributes["identifier"].should == subject.identifier.to_s
    end
  end

  describe Timezone::Unidentified do
    subject { Timezone::Unidentified.new }

    its(:identifier) { should be_nil }
    its(:name)       { should be_nil }
    its(:code)       { should be_nil }
    its(:offset)     { should be_zero }
  end
end
