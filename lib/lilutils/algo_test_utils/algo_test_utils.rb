# Provides for code useful to test algorithms, do benchmarks etc. For example, you might be testing a sorting algorithm
# and need 100_000 or 1_000_000 randomly generated (supposedly unsorted) strings. Of course, you are not going to test
# your algorithm with ten or hundred strings or numbers, right?
module AlgoTestUtils
  ALPHABET = ('a'..'z').to_a + ('0'..'9').to_a
  SIZE = ALPHABET.length

  # Returns random strings of <b> equal length </b>.
  # The length of each string is determined by the parameter passed.
  # The characters that can 
  def self.ascii_strings(size)
    raise ArgumentError, "Size must be positive" if size < 1
    srand(Time.now.to_i)
    strings = []
    of_length = get_string_length_for(size)
    1.upto size do
      strings << get_ascii_string(of_length)
    end
    strings
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

puts AlgoTestUtils.ascii_strings(ARGV[0].to_i).sort
