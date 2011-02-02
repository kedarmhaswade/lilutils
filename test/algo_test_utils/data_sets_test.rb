require "test/unit"
require "lilutils/algo_test_utils/data_sets"

class DataSetsTest < Test::Unit::TestCase

  DS = LilUtils::AlgoTestUtils::DataSets

  def test_ascii_strings
    strs = DS.ascii_strings(100, 5)
    assert_equal(100, strs.size)
  end
end