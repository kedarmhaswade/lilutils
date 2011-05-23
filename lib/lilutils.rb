$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'lilutils/cli_entry'
require 'lilutils/misc_entry'
require 'lilutils/algo_test_utils_entry'
module LilUtils
  VERSION = '0.0.1'
end
