# ============================================================
# FILE: 01_greet.rb
# PURPOSE: The very first Ruby exercise, ask a name, greet them.
# CONCEPTS: puts (print), gets (input), chomp, string interpolation
# ============================================================

puts "What is your name?"          # "puts" prints text to the terminal followed by a newline.
                                   # The text inside quotes is a "string", just a piece of text.

name = gets.chomp                 # "gets" pauses the program and waits for the user to type + press Enter.
                                   # ".chomp" removes the invisible newline character that Enter adds.
                                   # "name =" stores what the user typed into a variable called "name".
                                   # A variable is like a labeled box that holds a value.

puts "Hello, #{name}!"            # Prints a greeting. #{name} is "string interpolation", Ruby replaces
                                   # #{name} with whatever is stored in the "name" variable.
                                   # So if name is "Alice", it prints: Hello, Alice!
