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

  def test_set_clear_one
    bv = LilUtils::Misc::BitVector.new(1<<20) # 1 Mega-bits = 2**20 bits
    bv.set(512)
    bv.clear(512)
    assert_equal(0, bv.test(512))
  end

  def test_set_all
    n = 1_000
    bv = LilUtils::Misc::BitVector.new(n)
    0.upto(n-1) {|i| bv.set(i)}
    0.upto(n-1) {|i| assert_equal(1, bv.test(i))}
  end

  def test_edge_cases
    n = 1<<16 #=> 65,536 bits
    bv = LilUtils::Misc::BitVector.new(n)
    bv.set(0)
    assert_equal(1, bv.test(0))
    bv.set(1<<16-1)
    assert_equal(1, bv.test(1<<16-1))
    bv.clear(0)
    assert_equal(0, bv.test(0))
    bv.clear(1<<16-1)
    assert_equal(0, bv.test(1<<16-1))
  end

end