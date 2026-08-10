# ============================================================
# FILE: 08_structured_tasks.rb
# PURPOSE: Tasks stored as hashes with name + completion status.
# CONCEPTS: hashes, symbols (:name, :done), ternary operator (? :)
# ============================================================

tasks = []                        # Creates an empty array to hold task hashes (not just strings anymore).

def add_task(tasks, name)         # Defines add_task, takes the array and a task name string.
  task = { name: name, done: false }
                                  # Creates a HASH, a collection of key-value pairs inside {}.
                                  # :name is a "symbol" (like a labeled tag) mapped to the task name.
                                  # :done starts as false (the task is not yet complete).
                                  # Symbols are lightweight, fast identifiers used as hash keys.
  tasks << task                   # Adds the hash to the end of the tasks array.
end                               # Closes the method.

def list_tasks(tasks)             # Defines list_tasks to display all tasks with their status.
  tasks.each do |task|            # Loops through every hash in the tasks array.
                                  # Each "task" variable is a hash like { name: "Buy groceries", done: false }.
    status = task[:done] ? "✓" : " "
                                  # Reads the :done value from the hash. "?" is the ternary operator:
                                  # condition ? value_if_true : value_if_false
                                  # If done is true → status = "✓", otherwise status = " " (empty).
    puts "[#{status}] #{task[:name]}"
                                  # Prints the task with its status checkbox.
                                  # Example output: [✓] Buy groceries  or  [ ] Call the bank
  end                             # Closes the .each loop.
end                               # Closes the list_tasks method.

add_task(tasks, "Buy groceries")           # Adds the first task hash to the array.
add_task(tasks, "Finish portfolio project") # Adds the second task hash.
add_task(tasks, "Call the bank")           # Adds the third task hash.

list_tasks(tasks)                 # Prints all tasks, none are marked done yet.
