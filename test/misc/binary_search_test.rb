require "test/unit"
require File.dirname(__FILE__) + '/../../lib/lilutils/misc_entry'
require File.dirname(__FILE__) + '/../../lib/lilutils/algo_test_utils_entry'

class BinarySearchTest < Test::Unit::TestCase

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
  BinarySearch = LilUtils::Misc::BinarySearch
  def test_1_numbers_in_order?
    a = []
    1.upto(100_000) { |n| a << n}
    assert_equal(true, BinarySearch.in_order?(a))
    a << -1 # now they are unsorted
    assert_equal(false, BinarySearch.in_order?(a))
  end

  def test_sandwich_1
    a = []
    0.upto(999) {|x| a << x} # a 1000 element array with a[i] = i
    assert_equal([-1, 0], BinarySearch.sandwiching_indexes_for(-1, a))
    assert_equal([999, 1000], BinarySearch.sandwiching_indexes_for(1001, a))
    assert_equal([499, 500], BinarySearch.sandwiching_indexes_for(499.4, a))
    assert_equal([2, 2], BinarySearch.sandwiching_indexes_for(2, a))
    assert_equal([22, 22], BinarySearch.sandwiching_indexes_for(22.0, a))
  end
end