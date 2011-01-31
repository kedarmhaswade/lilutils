# Provides for code useful to test algorithms, do benchmarks etc. For example, you might be testing a sorting algorithm
# and need 100_000 or 1_000_000 randomly generated (supposedly unsorted) strings. Of course, you are not going to test
# your algorithm with ten or hundred strings or numbers, right?
module DataSets
  ALPHABET = ('a'..'z').to_a + ('0'..'9').to_a
  SIZE = ALPHABET.length

  # Returns random strings of <b> equal length </b>.
  # The length of each string is determined by the parameter passed.
  # The characters that can appear in returned strings are defined by
  # the {#ALPHABET}. 
  # @param howmany [Integer] How many random strings do you need?
  # @param rest [Integer] Optional arguments. First argument should be the length of
  # each string in returned set. If unspecified, this is calculated from first
  # argument, howmany, such that the length is enough to generate strings from the
  # entire ALPHABET.
  def self.ascii_strings(howmany, *rest)
    p howmany, rest if $DEBUG
    raise ArgumentError, "Size must be positive" if howmany < 1
    srand(Time.now.to_i)
    strings = []
    of_length = rest[0] ? rest[0] : get_string_length_for(howmany)
    1.upto howmany do
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

# Example:
puts DataSets.ascii_strings(10).sort
puts DataSets.ascii_strings(100, 10).sort
