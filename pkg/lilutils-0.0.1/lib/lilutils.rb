$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'lilutils/cli_entry.rb'
require 'lilutils/misc_entry.rb'
module Lilutils
  VERSION = '0.0.1'
end
