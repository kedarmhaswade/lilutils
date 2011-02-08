require "test/unit"
require File.dirname(__FILE__) + '/../../lib/lilutils'
require 'stringio'

class PascalTest < Test::Unit::TestCase

  PASCAL = LilUtils::Misc::Pascal
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

  def test_first_six
    rows = {1=>[1], 2=>[1, 2, 1], 3=>[1, 3, 3, 1], 4=>[1, 4, 6, 4, 1], 5=>[1, 5, 10, 10, 5, 1], 6=>[1, 6, 15, 20, 15, 6, 1]}
    p rows
    rows.each_pair do |row_no, row | 
      assert_equal(row, PASCAL.row(row_no))
    end
  end
end
