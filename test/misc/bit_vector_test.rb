require "test/unit"
require_relative "../../lib/lilutils/misc/bit_vector"

class BitVectorTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_set_test_one
    bv = LilUtils::Misc::BitVector.new(100)
    bv.set(4)
    assert_equal(1, bv.test(4))
  end
end