module LilUtils
  module Misc
    # Class to implement a bit vector that uses an array of Fixnums as its storage.
    # Implements the basic bit vector operations as specified.
    class BitVector

      BITS_PER_ITEM = 0.size * 8

      def initialize(size)
        raise ArgumentError, "size must be positive" if size <= 0
        @size = size
        @array = Array.new((size*1.0/BITS_PER_ITEM).ceil) {|i| 0} #=> array contains required # of Fixnums, initialized to zero
      end

      # Sets the 'i'th bit of this Bit Vector.
      # @param [Fixnum] i Represents the index of the bit from 0 to @size-1
      # @raise [ArgumentError] if 0 < i <= n
      def set(i)
        raise ArgumentError, "argument (#{i}) should be between 0 and #{@size}" if i < 0 or i >= @size
        @array[get_index(i)] ||= (1 << (i%BITS_PER_ITEM))
      end

      def test(i)
        raise ArgumentError, "argument (#{i}) should be between 0 and #{@size}" if i < 0 or i >= @size
        if @array[get_index(i)] & (1 << i%BITS_PER_ITEM)
      end

      def clear(i)
        raise ArgumentError, "argument (#{i}) should be between 0 and #{@size}" if i < 0 or i >= @size
        @array[get_index(i)] &= ~(1 << i%BITS_PER_ITEM)
      end

      private

      def get_index(i)
        i/BITS_PER_ITEM
      end
    end
  end

end