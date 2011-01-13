#!/usr/bin/env ruby

module CLI
  module SymbolProvider
    def to_sym
      sn = nil
      sn = self.simple_name if self.respond_to? :simple_name
      sn.downcase.to_sym if sn
    end

    def default_indicator
      sn = nil
      sn = self.simple_name if self.respond_to? :simple_name
      sn[0].upcase if sn
    end

    def key
      default_indicator.downcase
    end

    def valid_response?(r)
      r == "" ||  r == key
    end
  end

  class Yes
    include SymbolProvider

    def simple_name
      "Yes"
    end

    def to_i
      1
    end

    def !
      NO
    end
  end
  class No
    include SymbolProvider

    def simple_name
      "No"
    end

    def to_i
      0
    end

    def !
      YES
    end
  end

  class Cancel
    include SymbolProvider

    def simple_name
      "Cancel"
    end

    def to_i
      -1
    end
  end
  YES    = Yes.new
  NO     = No.new
  CANCEL = Cancel.new
  YNC    = [YES, NO, CANCEL]
  class YesNo
    DEFAULT_PROMPT = "Do you want to proceed?"

    def self.yes_by_default(prompt, io)
      yes_or_no(YES, prompt, true)
    end
    def self.yes_by_default
      yes_or_no(YES, DEFAULT_PROMPT, true)
    end

    def self.no_by_default(prompt)
      yes_or_no(NO, prompt, true)
    end

    def self.no_by_default
      yes_or_no(NO, DEFAULT_PROMPT, true)      
    end

    def initialize(default_option, prompt, strict)
      @default_option = default_option
      @prompt         = prompt
      @strict         = strict
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
      print "#{@prompt} #{format}"
      response = gets.chomp!
      chosen   = valid_response? response
      if @strict
        until chosen
          print "\n#{response} is invalid, #{@prompt} #{format}"
          response = gets.chomp!
          chosen   = valid_response? response
        end
      else
        chosen = @other_options[0] # some random option will be returne, works as expected in YesNo case
      end
      chosen
    end

    private
    def self.yes_or_no(default_option, prompt, strict)
      YesNo.new(default_option, prompt, strict)
    end
  end

  class YesNoCancel < YesNo
    def self.yes_by_default
      yes_or_no_or_cancel(YES, DEFAULT_PROMPT, true)
    end
    def self.no_by_default
      yes_or_no_or_cancel(NO, DEFAULT_PROMPT, true)
    end
    def self.cancel_by_default
      yes_or_no_or_cancel(CANCEL, DEFAULT_PROMPT, true)
    end

    def initialize(default_option, prompt, strict)
      @default_option = default_option
      @prompt = prompt
      @strict = strict
      @other_options = YNC - [@default_option]
    end
    private
    def self.yes_or_no_or_cancel(default_option, prompt, strict)
      YesNoCancel.new(default_option, prompt, strict)
    end
  end
end
#yn = CLI::YesNo.yes_by_default
#r = yn.run
#puts r
#ync = CLI::YesNoCancel.yes_by_default
#r = ync.run
#puts r
