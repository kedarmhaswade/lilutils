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
    is  = StringIO.open("y\n", "r")
    os  = StringIO.open("", "w")
    yes = CLI::YesNo.new(CLI::YES, CLI::YesNo::DEFAULT_PROMPT, true, is, os)
    assert_equal(CLI::YES, yes.show)

    is = StringIO.open("\n", "r") # just enter a newline character
    no = CLI::YesNo.new(CLI::NO, CLI::YesNo::DEFAULT_PROMPT, true, is, os)
    assert_equal(CLI::NO, no.show)

    is = StringIO.open("c\n", "r") # invalid character
    no = CLI::YesNo.new(CLI::NO, CLI::YesNo::DEFAULT_PROMPT, false, is, os) # we must not be strict here
    assert_equal(CLI::NO, no.show) # default should prevail as 'c' is not recognized

    is = StringIO.open("go away\nz\n\n", "r") # 2 invalid attempts and then a valid attempt to select the default
    no = CLI::YesNo.new(CLI::NO, CLI::YesNo::DEFAULT_PROMPT, false, is, os) # we must not be strict here
    assert_equal(CLI::NO, no.show) # default should prevail as we encounter a mere newline
    is.close
    os.close
  end

  def test_yes_no_cancel
    is = StringIO.open("", "r")
    os = StringIO.open("", "w")
    CLI::YNC.each do |option|
      is  = StringIO.open("#{option.key}\n", "r")
      ync = CLI::YesNoCancel.new(option, "test", true, is, os)
      assert_equal(option, ync.show)
    end
    CLI::YNC.each do |option|
      is  = StringIO.open("\n", "r") # default option matches a mere Enter
      ync = CLI::YesNoCancel.new(option, "test", true, is, os)
      assert_equal(option, ync.show)
    end
    is.close
    os.close
  end

  def test_display_string
    prompt  = "Pick one: "
    options = []
    options << CLI::SingleLetterOption.new("Coffee") << CLI::SingleLetterOption.new("Tea") << CLI::SingleLetterOption.new("Milk")
    # make Tea the default
    list     = CLI::OptionList.new(options, 1, prompt, true)
    expected = prompt + " [c/T/m] "
    assert_equal(expected, list.display_string)
  end

  def test_generic_1
    os       = StringIO.open("", "w")
    cat      = CLI::Option.new("cat")
    dog      = CLI::Option.new("dog")
    elephant = CLI::Option.new("elephant")
    frog     = CLI::Option.new("frog")

    is       = StringIO.open("z\ne\n", "r") # choose invalid option and then elephant
    list = CLI::OptionList.new([cat, dog, elephant, frog], 3, "", true, is, os)  # make frog the default
    assert_equal(elephant, list.show)

    is.close
    os.close
  end
  
  def test_numbers_1
    os       = StringIO.open("", "w")
    latte    = CLI::NumberedOption.new(1, "Latte")
    mocha    = CLI::NumberedOption.new(2, "Mocha")
    chai     = CLI::NumberedOption.new(3, "Chai")
    machiato = CLI::NumberedOption.new(4, "Caramel Machiato")
    is       = StringIO.open("3\n", "r") # choose Chai
    list     = CLI::NumberedOptions.new([latte, mocha, chai, machiato], 0, "Pick your favorite: ", true, is, os) # make latte the default
    assert_equal(chai, list.show)
    
    is.close
    os.close
  end

  def test_long_names
    os = StringIO.open("", "w")

    l = CLI::Option.new("Left Turn")
    r = CLI::Option.new("Right Turn")
    u = CLI::Option.new("U Turn")

    is = StringIO.open("u\n", "r") # take a U turn
    message = "What should I do?"
    list = CLI::OptionList.new([l, r, u], 1, message, true, is, os)
#    puts list.display_string
    assert_equal(u, list.show)

    is = StringIO.open("\n", "r") # right turn as default
    list = CLI::OptionList.new([l, r, u], 1, message, true, is, os)
    assert_equal(r, list.show) # enter = right

    is = StringIO.open("r\n", "r") # right turn explicit
    list = CLI::OptionList.new([l, r, u], 1, message, true, is, os)
    assert_equal(r, list.show) # right turn selected

    is = StringIO.open("e\nl\n", "r") # invalid and then left
    list = CLI::OptionList.new([l, r, u], 1, message, true, is, os)
    assert_equal(l, list.show) # left

    expected_display_string = "#{message} [Left turn (l)/*Right turn (r)*/U turn (u)] "
    assert_equal(expected_display_string, list.display_string)
  end
end
