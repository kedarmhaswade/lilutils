require "test/unit"
require File.dirname(__FILE__) + '/../../lib/lilutils/cli/cli.rb'
require 'stringio'

class BasicCLITest < Test::Unit::TestCase

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

  def test_symbols
    assert_equal(:yes, CLI::Yes.new.to_sym)
    assert_equal(:no, CLI::No.new.to_sym)
    assert_equal(:cancel, CLI::Cancel.new.to_sym)
  end

#  def test_yes_no_1
#    yes_by_default = CLI::YesNo.yes_by_default
#    assert_equal(CLI::YES, yes_by_default.run)
#  end
end