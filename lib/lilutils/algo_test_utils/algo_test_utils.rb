# Provides for code useful to test algorithms, benchmarks etc. For example, you might be testing a sorting algorithm
# and need 100_000 or 1_000_000 randomly generated (supposedly unsorted) strings. Of course, you are not going to test
# your algorithm with ten or hundred strings or numbers, right?
module AlgoTestUtils
  def self.ascii_strings(size)
    raise ArgumentError, "Size must be positive" if size < 1
    strings = []
    1.upto size do
      strings << get_string
    end
  end
end