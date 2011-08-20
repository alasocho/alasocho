require "test_helper"

class TimezoneTest < ActiveSupport::TestCase
  setup do
    @timezone = Timezone.get("America/New_York")
  end

  test "a timezone has a name" do
    assert_equal "America - New York", @timezone.name
  end

  test "a timezone has a code" do
    # FIXME: This test will break once New York is out of DST
    assert_equal :EDT, @timezone.code
  end

  test "a timezone has an offset" do
    # FIXME: This test will break once New York is out of DST
    assert_equal -4, @timezone.offset
  end
end

class NullTimezoneTest < ActiveSupport::TestCase
  setup do
    @timezone = Timezone::Unidentified.new
  end

  test "a null timezone doesn't have a name" do
    assert_nil @timezone.name
  end

  test "a null timezone doesn't have a code" do
    assert_nil @timezone.code
  end

  test "a null timezone has an offset of 0" do
    assert_equal 0, @timezone.offset
  end
end
