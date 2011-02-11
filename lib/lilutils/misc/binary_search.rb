module LilUtils
  module Misc
    module BinarySearch

      def self.sandwiching_indexes_for(value, array, fi=0, li=array.length-1, check_if_in_order=true)
        # it is __not__ assumed that the array is sorted, we skip the check if we are asked to
        if check_if_in_order
          raise ArgumentError, "Unordered array provided to this routine based on binary search" unless in_order? array
        end
        # make other checks
        while true
          i = fi + (li-fi+1)/2 # Google "nearly all binary searches are broken"
          return [i, i] if array[i] == value
          return [fi, li] if (fi+1) >= li and value >= array[fi] and value <=array[li]
          return [fi-1, fi] if (fi+1) >= li and value <= array[fi]
          return [li, li+1] if (fi+1) >= li and value >= array[fi]
          value < array[i] ? li = i : fi = i
          #puts "fi=#{fi}, li=#{li}"
        end
      end

      def self.in_order?(array, &block)
        block = Proc.new {|x, y| x <=> y} unless block_given?
        old_order = new_order = 0
        array.each_cons(2) do |a|
          new_order = block.call(a[0], a[1])
          return false if (new_order > 0 and old_order < 0) or (new_order < 0 and old_order > 0)
          old_order = new_order if new_order != 0
        end
        true
      end
    end
  end
end
#puts LilUtils::Misc::BinarySearch.in_order? ["rujuta", "kedar", "deepa", "apoorv"] {|x, y| x.length <=> y.length}
#puts LilUtils::Misc::BinarySearch.in_order? ["rujuta", "kedar", "apoorv", "deepa"]
#puts LilUtils::Misc::BinarySearch.in_order? ["rujuta", "kedar", "deepa", "apoorv"]
#puts LilUtils::Misc::BinarySearch.in_order? [6, 5, 5, 4]
#puts LilUtils::Misc::BinarySearch.in_order? [2, 1]
#puts LilUtils::Misc::BinarySearch.in_order? [1]
#puts LilUtils::Misc::BinarySearch.in_order? [1, 2]
#puts LilUtils::Misc::BinarySearch.sandwiching_indexes_for(25.2, [1, 4, 8, 8, 9, 12, 15, 23.4, 44])
#puts LilUtils::Misc::BinarySearch.sandwiching_indexes_for(0, [1])