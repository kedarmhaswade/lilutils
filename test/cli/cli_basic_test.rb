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

  def test_yes_no
    is = StringIO.open("y\n", "r")
    os = StringIO.open("", "w")
    yes = CLI::YesNo.new(CLI::YES, CLI::YesNo::DEFAULT_PROMPT, true, is, os)
    assert_equal(CLI::YES, yes.run)

    is = StringIO.open("\n", "r") # just enter a newline character
    no = CLI::YesNo.new(CLI::NO, CLI::YesNo::DEFAULT_PROMPT, true, is, os)
    assert_equal(CLI::NO, no.run)

    is = StringIO.open("c\n", "r") # invalid character
    no = CLI::YesNo.new(CLI::NO, CLI::YesNo::DEFAULT_PROMPT, false, is, os) # we must not be strict here
    assert_equal(CLI::NO, no.run) # default should prevail as 'c' is not recognized

    is = StringIO.open("go away\nz\n\n", "r") # 2 invalid attempts and then a valid attempt to select the default
    no = CLI::YesNo.new(CLI::NO, CLI::YesNo::DEFAULT_PROMPT, false, is, os) # we must not be strict here
    assert_equal(CLI::NO, no.run) # default should prevail as we encounter a mere newline

  end

  def test_yes_no_cancel

  end
end
