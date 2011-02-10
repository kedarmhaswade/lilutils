module LilUtils
  module Misc
    module Pascal
      # Returns the nth row of the Pascal's triangle as an array of n+1 elements.
      # This is an O(n) algorithm. Uses: nCr = nCr-1*(n-r+1)/r which calculates
      # an element using the previous element (which is already initialized or
      # calculated). Thus, it does not throw away any computation. The constant
      # factors of this alogirthm are also good (~0.5).
      # @param [Integer] n starts at 1
      # @return [Array] of Integers representing numbers in given row.
      def self.row(n)
        raise ArgumentError, "#{n} is not valid" if !n.is_a?(Integer) || n < 1
        len = n == 1 ? 1 : n + 1
        a = Array.new(len); a[0] = a[-1] = 1 # by definition
        1.upto n/2 do |r|
          a[r] = a[-r-1] = a[r-1] * (n-r+1)/r
        end
        a
      end
    end
  end
end
#p LilUtils::Misc::Pascal.row(ARGV[0].to_i)
