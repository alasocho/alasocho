require "unit_spec_helper"
require "timezone"

describe Timezone do
  subject { Timezone.get("America/New_York") }

  its(:identifier) { should == "America/New_York" }
  its(:name)       { should == "America - New York" }
  its(:code)       { should == :EDT }
  its(:offset)     { should == -4 }

  describe Timezone::Unidentified do
    subject { Timezone::Unidentified.new }

    its(:identifier) { should be_nil }
    its(:name)       { should be_nil }
    its(:code)       { should be_nil }
    its(:offset)     { should be_zero }
  end
end
