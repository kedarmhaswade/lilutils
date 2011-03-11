require "test/unit"
require "minitest/unit"
require File.dirname(__FILE__) + '/../../lib/lilutils/algo_test_utils/data_sets'

class DataSetsTest < Test::Unit::TestCase

  DS = LilUtils::AlgoTestUtils::DataSets

  def test_ascii_strings
    strs = DS.ascii_strings(100, 5)
    assert_equal(100, strs.size)
  end

  def test_select_random_array
    assert_equal((0...5).to_a, DS.select_random_array(5, 5))
  end

  def test_select_random_array_1_of_4
    a0, a1, a2, a3 = [0, 1, 2], [0, 1, 3], [0, 2, 3], [1, 2, 3]
    probables = [a0, a1, a2, a3]
    actual = DS.select_random_array(3, 4)
    assert_true(probables.member? actual)
  end
end