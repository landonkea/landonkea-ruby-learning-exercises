# ============================================================
# FILE: 02_conditional.rb
# PURPOSE: Greet differently based on who the user is.
# CONCEPTS: if/else, string comparison (==), variables
# ============================================================

puts "What is your name?"          # Prints the question to the terminal so the user knows what to type.

name = gets.chomp                 # Waits for user input, strips the trailing newline, stores it in "name".

if name == "Landon"               # "if" starts a conditional check. "==" compares two values for equality.
                                  # This checks: is the name exactly the string "Landon"?
  puts "Hey, it's you!"           # This runs ONLY if name equals "Landon", a special greeting.

else                              # "else" catches every other case, if name is NOT "Landon".
  puts "Hello, #{name}!"          # Generic greeting using string interpolation with the user's name.

end                               # "end" closes the if/else block. Ruby needs this to know where the
                                  # conditional stops.
