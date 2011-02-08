module LilUtils
  module AlgoTestUtils
    module Pascal
      # Returns the nth row of the Pascal's triangle as an array of n+1 elements.
      # This is an O(n) algorithm. Uses: nCr = nCr-1*(n-r+1)/r which calculates
      # @param [Integer] n starts at 1
      # @return [Array] of Integers representing numbers in given row.
      def self.row(n)
        raise ArgumentError if !n.is_a?(Integer) || n < 1
        len = n == 1 ? 1 : n + 1
        a = Array.new(len); a[0] = a[-1] = 1
        r = 1
        while r <= n/2
          a[r] = a[-r-1] = a[r-1] * (n-r+1)/r
          r += 1
        end
        a
      end
    end
  end
end
p LilUtils::AlgoTestUtils::Pascal.row(5)