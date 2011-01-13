#!/usr/bin/env ruby
class Module
  # suggested by Brian Candler
  def simple_name
    name.gsub(/^.*::/,'')
  end
end

module CLI
  module OptionHelper
    def to_sym
      self.class.simple_name.downcase.to_sym
    end

    def default_indicator
      self.class.simple_name[0].upcase
    end

    def key
      default_indicator.downcase
    end

    def valid_response?(r)
      r == "" ||  r == key
    end
  end

  class Yes
    include OptionHelper

    def !
      NO
    end
  end
  class No
    include OptionHelper
    def !
      YES
    end
  end

  class Cancel
    include OptionHelper
  end
  YES    = Yes.new
  NO     = No.new
  CANCEL = Cancel.new
  YNC    = [YES, NO, CANCEL]
  class YesNo
    DEFAULT_PROMPT = "Do you want to proceed?"

    def initialize(default_option=YES, prompt=DEFAULT_PROMPT, strict=true, istream=$stdin, ostream=$stdout)
      @default_option = default_option
      @prompt         = prompt
      @strict         = strict
      @istream        = istream
      @ostream        = ostream
      @other_options  = []
      @other_options << !default_option
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
      @prompt = prompt
      @strict = strict
      @istream        = istream
      @ostream        = ostream
      @other_options = YNC - [@default_option]
    end
  end
end
yn = CLI::YesNo.new
r = yn.run
puts r
ync = CLI::YesNoCancel.new
r = ync.run
puts r
