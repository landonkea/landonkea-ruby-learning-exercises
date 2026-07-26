# ============================================================
# FILE: 09_mark_complete.rb
# PURPOSE: Mark a task as done by finding it by name.
# CONCEPTS: searching arrays, modifying hash values, .each with conditional
# ============================================================

tasks = []                        # Creates an empty array to store task hashes.

def add_task(tasks, name)         # Defines add_task to add a new task to the array.
  task = { name: name, done: false }
                                  # Creates a hash with two keys: :name (the task text) and :done (false).
  tasks << task                   # Pushes the hash onto the end of the tasks array.
end                               # Closes the method.

def list_tasks(tasks)             # Defines list_tasks to display all tasks with checkboxes.
  tasks.each do |task|            # Loops through each task hash in the array.
    status = task[:done] ? "✓" : " "
                                  # Ternary operator: if :done is true show "✓", otherwise show " ".
    puts "[#{status}] #{task[:name]}"
                                  # Prints formatted task like: [✓] Buy groceries
  end                             # Closes the loop.
end                               # Closes list_tasks.

def complete_task(tasks, name)    # Defines a NEW method — finds a task by name and marks it done.
  tasks.each do |task|            # Loops through every task hash in the array.
    if task[:name] == name        # Checks if this task's :name matches the name we're looking for.
      task[:done] = true          # If it matches, set :done to true — the task is now complete!
    end                           # Closes the if statement.
  end                             # Closes the loop. (If no match found, nothing happens.)
end                               # Closes complete_task.

add_task(tasks, "Buy groceries")           # Adds three tasks to the list.
add_task(tasks, "Finish portfolio project")
add_task(tasks, "Call the bank")

complete_task(tasks, "Buy groceries")      # Finds "Buy groceries" and marks it done.

list_tasks(tasks)                 # Prints all tasks — "Buy groceries" should now show [✓].
