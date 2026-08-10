# ============================================================
# FILE: 05_function.rb
# PURPOSE: Wrap greeting logic in a reusable function (method).
# CONCEPTS: def/end (method definition), parameters, calling methods
# ============================================================

def greet(name)                   # "def" starts a method definition. "greet" is the method's name.
                                  # "(name)" is a parameter, a placeholder for data the caller provides.
                                  # Think of it as an input slot that must be filled when calling greet.
  if name == "LandonTheFirst"     # Checks if the passed-in name equals "LandonTheFirst".
    puts "Hey, it's you!"         # Special greeting for that specific name.
  else                            # All other names get the generic greeting below.
    puts "Hello, #{name}!"        # Prints a personalized greeting using string interpolation.
  end                             # Closes the if/else block.
end                               # Closes the method definition. greet is now usable anywhere below.

greet("LandonTheFirst")           # Calls greet with "LandonTheFirst", triggers the special greeting.
greet("LandonTheSecond")          # Calls greet with "LandonTheSecond", triggers the generic greeting.
greet("LandonTheThird")           # Calls greet with "LandonTheThird", also gets the generic greeting.
