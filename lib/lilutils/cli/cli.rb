#!/usr/bin/env ruby

# Adds the simple_name method to Module.
# @note A simple_name is just the name of the class/module without encompassing modules
class Module
  # suggested by Brian Candler
  def simple_name
    name.gsub(/^.*::/, '')
  end
end

# The main module
# Provides functionality to interact with users on a <i> command line </i>
module CLI
  # A (sub) module that is used as a mixin to define the functionality of options. An option is generally
  # recognized by a (lower-case) ASCII character (Yes, not caring for multibyte characters at the moment).
  module OptionHelper
    # Indicates that the option is the default one.
    # @return [String] a character in upper case suggesting that that option is the default (e.g. 'Y' for YES)
    def default_indicator
      self.class.simple_name[0].upcase
    end

    # Indicates the ASCII key that represents this option. This is always lower case.
    # @return [String] a character in lower case identifying an option
    def key
      default_indicator.downcase
    end

    # Decides whether the response is valid. A response is valid only if it is equal (==) to the key.
    # @return true if it's a valid response, false otherwise
    def valid_response?(r)
       r == key
    end
  end

  # Marker class for an option
  class Option
  end
  # The class that identifies a user "Yes".
  class Yes < Option
    include OptionHelper
    def !
      NO
    end
  end

  # The class that identifies a user "No".
  class No < Option
    include OptionHelper
    def !
      YES
    end
  end

  # The class that identifies a user "Cancel".
  class Cancel < Option
    include OptionHelper
  end

  # Singletons
  YES    = Yes.new
  NO     = No.new
  CANCEL = Cancel.new
  YNC    = [YES, NO, CANCEL]

  # A class that models the simple yes/no interaction with user on command line. Provides several ways to customize.
  # @example:
  # ...
  # Do you want to proceed [Y/n]? y (Enter)
  # A simple Enter or 'y' returns the YES object. Pressing n returns NO object. Pressing anything else returns a
  # value that depends on the mode which can be <i>strict</i>. If the mode is strict, it keeps on asking the user till s/he
  # presses the correct key. If the mode is not strict, any invalid key (other than y, n, or enter) results in whatever
  # the default option is. Note that the default option is shown as upper case key.
  # @see CLI#YES
  # @see #NO
  class YesNo
    DEFAULT_PROMPT = "Do you want to proceed?"

    # Creates a YesNo interaction.
    # @param [Option] default_option the option that should be treated as default. Its default is #YES :-)
    # @param [String] prompt prompt that should appear. Default is #DEFAULT_PROMPT
    # @param [Boolean] strict decides if the interaction should demand exact response and loop till user behaves
    # @param [IO] istream input stream to read user response from
    # @param [IO] ostream output stream to display output to
    def initialize(default_option=YES, prompt=DEFAULT_PROMPT, strict=true, istream=$stdin, ostream=$stdout)
      @default_option = default_option
      @prompt         = prompt
      @strict         = strict
      @istream        = istream
      @ostream        = ostream
      @other_options  = [!default_option]
    end

    def options
      [@default_option] + @other_options
    end

    def valid_response?(r)
      options.each do |option|
        return option if (option == @default_option && r == "") || (option.valid_response? r)
      end
      nil
    end

    # subclasses may override, but don't have to
    def format
      form = "%s" % [@default_option.default_indicator]
      @other_options.each do |opt|
        form += "/%s" % opt.key
      end
      "[#{form}] "
    end

    # the whole point is subclasses get this for free
    def run
      @ostream.print "#{@prompt} #{format}"
      response = @istream.gets.chomp!
      chosen   = valid_response? response
      if @strict
        until chosen
          @ostream.print "\nSorry, I don't understand #{response}, #{@prompt} #{format}"
          response = @istream.gets.chomp!
          chosen   = valid_response? response
        end
      else
        chosen = @default_option # when not strict, any key => default option
      end
      chosen
    end
  end

  class YesNoCancel < YesNo
    def initialize(default_option=YES, prompt=DEFAULT_PROMPT, strict=true, istream=$stdin, ostream=$stdout)
      @default_option = default_option
      @prompt         = prompt
      @strict         = strict
      @istream        = istream
      @ostream        = ostream
      @other_options  = YNC - [@default_option]
    end
  end
end
#yn = CLI::YesNo.new
#r = yn.run
#puts r
#yn = CLI::YesNo.new(CLI::NO)
#r = yn.run
#puts r
#ync = CLI::YesNoCancel.new
#r = ync.run
#puts r
