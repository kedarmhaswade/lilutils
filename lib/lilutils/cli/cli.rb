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

  # Denotes an arbitrary option.
  class Option
    attr_reader :name
    # constructs this option with a name. The first character of this is regarded its key, e.g. "Yes" and 'y'.
    # Unless an option has a proper name (e.g. "Mozart"), do not use the default value of the parameter
    def initialize(name=self.class.simple_name)
      @name = name.capitalize
      @name.freeze
    end

    def ==(other)
      (other.is_a? Option) && (@name == other.name)
    end

    def valid_response(r)
      key == r
    end

    def as_default
      key.upcase
    end

    def as_non_default
      key
    end

    def to_s
      @name
    end

    def key
      @name[0].downcase
    end
  end
  # The class that identifies a user "Yes".
  class Yes < Option
  end

  # The class that identifies a user "No".
  class No < Option
  end

  # The class that identifies a user "Cancel".
  class Cancel < Option
  end

  # An option with a name and a positive number used to identify its selection
  class NumberedOption < Option
    attr_reader :number
    def initialize(number, name)
      super(name)
      @number = number
    end
    # redefine
    def ==(other)
      @name == other.name  && @number == other.number
    end
    # redefine
    def valid_response(r)
      @number.to_s == r
    end
    # redefine
    def as_default
      "*#{@name} (#{@number})*"
    end
    # redefine
    def as_non_default
      "#{@name} (#{@number})"
    end
    def to_s
      "#{@name}, #{number}"
    end
  end

  # Singletons
  YES    = Yes.new
  NO     = No.new
  CANCEL = Cancel.new
  YN     = [YES, NO]
  YNC    = YN + [CANCEL]

  class OptionList
    DEFAULT_PROMPT = "Do you want to proceed?"

    def initialize(options, default_option_index, prompt, strict, istream=$stdin, ostream=$stdout)
      # check, list must be non-nil and must have at least two elements
      @options        = options
      @default_option = options[default_option_index]
      @prompt         = prompt
      @strict         = strict
      @istream        = istream
      @ostream        = ostream
    end

    def valid_response?(r)
      @options.each do |option|
        debug "#{option} == #{@default_option} ? : (#{option == @default_option})"
        return option if (option == @default_option && r == "") || (option.valid_response(r))
      end
      nil
    end

    # subclasses may override, but don't have to
    def display_string
      long_str = ""
      @options.each_with_index do |option, index|
        if option == @default_option
          long_str << option.as_default
        else
          long_str << option.as_non_default
        end
        long_str << "/" if index < (@options.size-1)
      end
      "#{@prompt} [#{long_str}] "
    end

    # the whole point is subclasses get this for free
    def show
      @ostream.print "#{display_string}"
      response = @istream.gets.chomp!
      chosen   = valid_response? response
      if @strict
        until chosen
          @ostream.print "\nSorry, I don't understand #{response}, #{@prompt} #{display_string}"
          response = @istream.gets.chomp!
          chosen   = valid_response? response
        end
      else
        chosen = @default_option # when not strict, any key => default option
      end
      chosen
    end

    def debug(str)
      puts "debug: #{str}" if $DEBUG
    end
  end
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
  class YesNo < OptionList
    # Creates a YesNo interaction.
    # @param [Option] default_option the option that should be treated as default. Its default is #YES :-)
    # @param [String] prompt prompt that should appear. Default is #DEFAULT_PROMPT
    # @param [Boolean] strict decides if the interaction should demand exact response and loop till user behaves
    # @param [IO] istream input stream to read user response from
    # @param [IO] ostream output stream to display output to
    def initialize(default_option=YES, prompt=DEFAULT_PROMPT, strict=true, istream=$stdin, ostream=$stdout)
      super(YN, YN.index(default_option), prompt, strict, istream, ostream)
    end

  end

  class YesNoCancel < OptionList
    def initialize(default_option=YES, prompt=DEFAULT_PROMPT, strict=true, istream=$stdin, ostream=$stdout)
      super(YNC, YNC.index(default_option), prompt, strict, istream, ostream)
    end
  end
  class NumberedOptions < OptionList
    def initialize(options, default_option_index, prompt, strict, istream=$stdin, ostream=$stdout)
      # all the options must be NumberedOption instances
      super
    end
  end
end
#puts CLI::YesNo.new.show
#puts CLI::YesNo.new(CLI::NO).show
#puts CLI::YesNoCancel.new.show
#puts CLI::OptionList.new([CLI::Option.new("Mozart"), CLI::Option.new("Beethoven")], 1, "Pick your pick: ", true).show
#one = CLI::NumberedOption.new(1, "Standard")
#two = CLI::NumberedOption.new(2, "Expedite")
#three = CLI::NumberedOption.new(3, "Special")
#puts CLI::NumberedOptions.new([one, two, three], 0, "Select shipping method: ", true).show
