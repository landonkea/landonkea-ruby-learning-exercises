# ============================================================
# WEIGHT CONVERTER, fully explicit with every parenthesis shown
# and every line commented for a before-novice reader
# ============================================================
# HOW TO READ THESE COMMENTS:
# Lines starting with # are comments, Ruby ignores them completely.
# They are notes left by humans, for humans.
# The actual code is everything that does NOT start with #.
# ============================================================




# ============================================================
# METHOD 1: lbs_to_kg
# Purpose: take a weight number in pounds, return it in kilograms
# ============================================================

def lbs_to_kg(weight)                  # "def" means "define a method". The method is named lbs_to_kg.
                                        # (weight) is the INPUT, a number this method receives when called.
                                        # Think of (weight) as a labeled box the caller drops a number into.

  result = (weight / 2.205)             # Divide whatever number is in the "weight" box by 2.205.
                                        # 2.205 is the conversion factor: 1 kg = 2.205 lbs.
                                        # The parentheses make explicit that division happens first.
                                        # Store the answer in a new box called "result".

  return result.round(2)                # .round(2) trims the decimal to 2 places. e.g. 70.00453 becomes 70.0.
                                        # "return" sends this value back OUT of the method to whoever called it.
                                        # Explicit return: we are being deliberate about what leaves this method.

end                                     # "end" closes the method definition that "def" opened above.




# ============================================================
# METHOD 2: kg_to_lbs
# Purpose: take a weight number in kilograms, return it in pounds
# ============================================================

def kg_to_lbs(weight)                  # Same structure as above, define a method, receive one input called weight.

  result = (weight * 2.205)             # Multiply by 2.205 this time (going the other direction: kg → lbs).
                                        # Parentheses again make the order of operations visually explicit.

  return result.round(2)                # Trim to 2 decimal places and send the value back to the caller.

end                                     # Close the method.




# ============================================================
# METHOD 3: print_lbs_to_kg
# Purpose: call lbs_to_kg and print a human-readable sentence
# ============================================================

def print_lbs_to_kg(weight)            # Define a method. Receives one input: a number in pounds.

  converted = lbs_to_kg(weight)        # Call the lbs_to_kg method we defined above, pass (weight) into it.
                                        # lbs_to_kg does the math and RETURNS a number.
                                        # We catch that returned number and store it in a box called "converted".

  puts("Your weight is #{converted} kg") # "puts" prints a line of text to the terminal, then moves to a new line.
                                        # The parentheses after puts make explicit that we are passing it an argument.
                                        # #{converted} is called STRING INTERPOLATION, Ruby reaches into the
                                        # "converted" box, grabs the number, and drops it into the middle of the string.
                                        # The final string might look like: "Your weight is 70.31 kg"

end                                     # Close the method.




# ============================================================
# METHOD 4: print_kg_to_lbs
# Purpose: call kg_to_lbs and print a human-readable sentence
# ============================================================

def print_kg_to_lbs(weight)            # Define a method. Receives one input: a number in kilograms.

  converted = kg_to_lbs(weight)        # Call kg_to_lbs, pass in the weight. Store the returned number in "converted".

  puts("Your weight is #{converted} lbs") # Print the result sentence. Same interpolation as above, just says "lbs".

end                                     # Close the method.




# ============================================================
# METHOD 5: get_user_input
# Purpose: ask the user questions, collect their answers, return them
# ============================================================

def get_user_input()                   # Define a method. Empty parentheses () = no inputs needed from a caller.
                                        # This method gets its data FROM THE USER TYPING, not from another method.

  puts("What is your weight?")         # Print a question to the terminal so the user knows what to type.

  raw_input = gets()                   # "gets" PAUSES the program and waits for the user to type something
                                        # and press Enter. Whatever they typed (including the Enter keystroke)
                                        # is stored in a box called "raw_input". The () makes explicit we call gets.

  trimmed = raw_input.chomp()          # .chomp() removes the invisible newline character that Enter adds to the end.
                                        # Without this, "150\n" stays "150\n", the \n causes problems later.
                                        # After chomp: "150\n" becomes "150".

  weight = trimmed.to_f()              # .to_f() converts the string "150" into the number 150.0
                                        # "to_f" means "to float", a float is a number that can have decimals.
                                        # We need a number (not text) because we're going to do math with it.
                                        # Store the number in a box called "weight".

  if(weight <= 0)                      # "if" checks a condition. The parentheses make the condition visually explicit.
                                        # weight <= 0 means "is the weight less than or equal to zero?"
                                        # This catches negative numbers and zero, which aren't valid weights.

    puts("Please enter a weight greater than zero.") # Tell the user what went wrong.

    return get_user_input()            # "return" here exits this method immediately and calls ITSELF again.
                                        # This is called RECURSION, the method restarts from the top.
                                        # The user gets asked the question again until they give a valid number.

  end                                  # Close the "if" block.

  puts("Is that in (L)bs or (K)g?")   # Ask the user which unit their number is in.

  raw_unit = gets()                    # Pause and wait for the user to type "L", "K", or anything else.

  unit = raw_unit.chomp().downcase()   # .chomp() removes the Enter keystroke again.
                                        # .downcase() converts whatever they typed to lowercase.
                                        # So "L", "l", "LBS" all become "l". Prevents case-mismatch bugs.
                                        # Store the cleaned result in a box called "unit".

  return weight, unit                  # Return TWO values at once back to whoever called this method.
                                        # Ruby allows this, the two values travel together as a pair.
                                        # The caller can unpack them into two separate boxes.

end                                    # Close the method.




# ============================================================
# METHOD 6: print_weight_conversion
# Purpose: decide WHICH conversion to run based on the unit the user gave
# ============================================================

def print_weight_conversion(weight, unit) # Define a method. Receives TWO inputs: the number and the unit letter.

  case(unit)                           # "case" is like a multi-way if statement. It looks at the value in "unit".
                                        # Parentheses make explicit what we are examining.

  when("l")                            # If unit is exactly the string "l" (lowercase L)...
    print_lbs_to_kg(weight)            # ...call the print method for pounds-to-kg, pass in the weight.

  when("k")                            # If unit is exactly the string "k"...
    print_kg_to_lbs(weight)            # ...call the print method for kg-to-pounds, pass in the weight.

  else                                 # If unit is anything other than "l" or "k" (e.g. "x", "z", "hello")...
    puts("I don't support that unit of measurement") # ...tell the user we don't know what they meant.

  end                                  # Close the "case" block.

end                                    # Close the method.




# ============================================================
# METHOD 7: main
# Purpose: the conductor, calls the other methods in the right order,
#          keeps the program running until the user decides to quit
# ============================================================

def main()                             # Define the main method. No inputs needed, it runs the whole show.

  loop do                              # "loop do" starts an infinite loop. It will repeat forever...
                                        # ...until it hits a "break" instruction somewhere inside it.

    weight, unit = get_user_input()    # Call get_user_input(). It returns two values.
                                        # We unpack them into two boxes: "weight" gets the number, "unit" gets the letter.
                                        # This is called PARALLEL ASSIGNMENT, two boxes filled in one line.

    print_weight_conversion(weight, unit) # Call the conversion decider, hand it both boxes.
                                        # It will figure out which direction to convert and print the result.

    puts("Convert another? (y/n)")     # Ask the user if they want to go again.

    answer = gets().chomp().downcase() # Wait for input, remove the newline, lowercase it. Store in "answer".

    if(answer != "y")                  # "!=" means "not equal to". If the user did NOT type "y"...
      break                            # ..."break" exits the loop immediately. The program ends.
    end                                # Close the if block. If they DID type "y", we do nothing here,
                                        # the loop just cycles back to the top and starts over.

  end                                  # Close the "loop do" block.

end                                    # Close the main method.




# ============================================================
# ENTRY POINT, this is the only line that actually RUNS on its own.
# Everything above is just definitions sitting in memory, doing nothing.
# This single line is what kicks the whole program off.
# ============================================================

main()                                 # Call the main method. No inputs needed.
                                        # This is where execution begins. main() calls get_user_input(),
                                        # which calls gets(), which calls nothing, it waits for the human.
                                        # The whole chain unwinds from this one line at the bottom.
