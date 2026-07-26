# ============================================================
# FILE: 03_loop.rb
# PURPOSE: Repeat a greeting a fixed number of times.
# CONCEPTS: gets, chomp, .times loop, string interpolation
# ============================================================

puts "What is your name?"          # Asks the user for their name by printing to the terminal.

name = gets.chomp                 # Reads user input from the keyboard, removes the Enter newline,
                                  # and stores the result in a variable called "name".

3.times do                        # ".times" is a loop that runs the block of code between do/end
                                  # exactly 3 times. "3.times" means "do this 3 times".
  puts "Hello, #{name}!"          # Each time through the loop, prints a greeting with the user's name.
                                  # So if name is "Bob", it prints "Hello, Bob!" three times.
end                               # "end" closes the .times block. Everything between do and end repeats.

