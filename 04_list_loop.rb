# ============================================================
# FILE: 04_list_loop.rb
# PURPOSE: Loop through a list (array) and greet each item.
# CONCEPTS: arrays, .each iterator, string interpolation
# ============================================================

names = ["LandonTheFirst", "LandonTheSecond", "LandonTheThird"]
                                  # Creates an "array", an ordered list of strings.
                                  # Arrays use square brackets [] and separate items with commas.
                                  # Each item has a position: index 0, 1, 2, etc.

names.each do |name|              # ".each" loops through every item in the array.
                                  # "|name|" is a block variable, on each pass, it holds the current item.
                                  # First pass: name = "LandonTheFirst", second: "LandonTheSecond", etc.
  puts "Hello, #{name}!"          # Prints a greeting for the current name in the loop.
end                               # "end" closes the .each block. The loop is done when all items are visited.
