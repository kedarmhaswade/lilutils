#!/usr/bin/env ruby

module CLI
  # constant definitions first
  # use the following as singletons
  module SymbolProvider
    def to_sym
      sn = nil
      sn = self.simple_name if self.respond_to? :simple_name
      sn.downcase.to_sym if sn
    end

    def default_indicator
      sn = nil
      sn = self.simple_name if self.respond_to? :simple_name
      sn[0].upcase
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

  class YesNo
    DEFAULT_YES_NO_PROMPT = "Do you want to proceed?"

    def self.yes_by_default(prompt, io)
      yes_or_no(YES, prompt, true)
    end
    def self.yes_by_default
      yes_or_no(YES, DEFAULT_YES_NO_PROMPT, true)
    end

    def self.no_by_default(prompt)
      yes_or_no(NO, prompt, true)
    end

    def self.no_by_default
      yes_or_no(NO, DEFAULT_YES_NO_PROMPT, true)      
    end

    def initialize(default_option, prompt, strict)
      @default_option = default_option
      @prompt         = prompt
      @strict         = strict
    end

    def options
      [YES, NO]
    end

    def valid_response?(r)
      options.each do |option|
        return option if option.valid_response? r
      end
      nil
    end

    def run
      form = "[%s/%s]" % [@default_option.default_indicator, (!@default_option).key]
      print "#{@prompt} #{form}"
      response = gets.chomp!
      chosen   = valid_response? response
      if @strict
        until chosen
          print "\n#{response}, Huh? #{@prompt} #{form}"
          response = gets.chomp!
          chosen   = valid_response? response
        end
      else
        chosen = !@default_option
      end
      chosen
    end

    private
    def self.yes_or_no(default_option, prompt, strict)
      YesNo.new(default_option, prompt, strict)
    end
  end
end
#yn = CLI::YesNo.yes_by_default
#r = yn.run
#puts r