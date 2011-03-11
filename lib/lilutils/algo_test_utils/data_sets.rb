# Provides for code useful to test algorithms, do benchmarks etc. For example, you might be testing a sorting algorithm
# and need 100_000 or 1_000_000 randomly generated (supposedly unsorted) strings. Of course, you are not going to test
# your algorithm with ten or hundred strings or numbers, right?
module LilUtils
  module AlgoTestUtils
    module DataSets
      ALPHABET = ('a'..'z').to_a + ('0'..'9').to_a
      SIZE = ALPHABET.length

      # Returns random strings of <b> equal length </b>.
      # The length of each string is determined by the parameter passed.
      # The characters that can appear in returned strings are defined by
      # the {#ALPHABET}.
      # @param [Integer] howmany How many random strings do you need?
      # @param [Integer] rest Optional arguments. First argument should be the length of
      # each string in returned set. If unspecified, this is calculated from first
      # argument, howmany, such that the length is enough to generate strings from the
      # entire ALPHABET.
      def self.ascii_strings(howmany, *rest)
        p howmany, rest if $DEBUG
        raise ArgumentError, "Size must be positive integer" if howmany < 1
        srand(Time.now.to_i)
        strings = []
        of_length = rest[0] ? rest[0] : get_string_length_for(howmany)
        1.upto howmany do
          strings << get_ascii_string(of_length)
        end
        strings
      end

      # Returns an array of k randomly chosen numbers between [0, n) where each number will be chosen with
      # equal probability. Note that returned array will be sorted. The algorithm is taken from Jon Bentley's excellent
      # Programming Pearls. To make the method to what you mean, both select_random(n, k) and select_random(k, n) do
      # the same thing, i.e. return an array of size k, each element of array is between 0 and n-1.
      # @param [Integer] k the number of numbers to choose. May not be > n
      # @param [Integer] n the upper limit, never included in returned array
      # @return [Array] Integer array of size k such that 0 <= Array[i] < n for all 0 <=i <= k
      def self.select_random_array(k, n)
        raise ArgumentError, "k, n should be non-negative" if k < 0 or n < 0
        k <= n ? (select, remaining = k, n) : (select, remaining = n, k)
        a = []
        big = 1 << 32 # 4B is a big number?
        0.upto(n-1) do |num|
          return a if select == 0
          if ((rand(big) % remaining) < select)
            a << num
            select -= 1
          end
          remaining -= 1
        end
        a
      end

      def self.random_enumerator(k, n, &block)
        Enumerator.new do |yielder|

        end
      end

      private

      def self.get_ascii_string(length)
        i = 0
        str = ""
        while i < length
          str << ALPHABET[rand(SIZE)]
          i += 1
        end
        str
      end

      def self.get_string_length_for(size)
        length = 0
        while size > 0
          length += 1
          size /= SIZE
        end
        length
      end
    end
  end
end
# Example:
#DataSets = LilUtils::AlgoTestUtils::DataSets
#puts DataSets.ascii_strings(10).sort
#puts DataSets.ascii_strings(100, 10).sort
