# ============================================================
# FILE: 06_return.rb
# PURPOSE: Return a value from a method instead of printing directly.
# CONCEPTS: method return values, implicit return, variables storing results
# ============================================================

def build_greeting(name)          # Defines a method named "build_greeting" that takes one input: "name".
  if name == "Landon"             # Checks if the name equals "Landon".
    "Hey, it's you!"              # This is the RETURN VALUE. In Ruby, the last expression in a method
                                  # is automatically returned — no "return" keyword needed.
                                  # This is called "implicit return".
  else                            # If name is anything other than "Landon"...
    "Hello, #{name}!"             # ...return this string instead. Both branches return a string.
  end                             # Closes the if/else.
end                               # Closes the method.

message = build_greeting("Landon")  # Calls build_greeting, gets back "Hey, it's you!",
                                    # and stores it in a variable called "message".
puts message                        # Prints the stored greeting to the terminal.

message2 = build_greeting("NotLandon")  # Calls it again with a different name.
                                        # Gets back "Hello, NotLandon!" and stores in message2.
puts message2                           # Prints the second greeting.
