#!/usr/bin/env ruby

module CLI
  class Yes

  end
  class No
  end
  OPTIONS = {yes: 1, no: 0}
  
  class YesNo
  def self.yes_by_default
    yes_or_no(OPTIONS[:yes])
  end
  def self.no_by_default
    yes_or_no(OPTIONS[:yes])
  end
  def initialize
    @my_default = :yes
  end
  def initialize(my_default)
    @my_default = my_default
  end
  def to_display_string(before, after)
    s = ""
    s << before if before
    s << after if after
  end
  private
  def self.yes_or_no(option)
    if option == :yes
      form = "[Y/n]"
    else
      form = "[y/N]"
    end
    puts "Do you want to proceed? #{form}"
    response = gets.chomp!
  end
end
