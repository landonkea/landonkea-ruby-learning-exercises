# ============================================================
# FILE: 10_save_tasks.rb
# PURPOSE: Save tasks to a file so they persist between runs.
# CONCEPTS: require, JSON library, File.write, .to_json
# ============================================================

require "json"                    # "require" loads an external library. "json" lets Ruby read/write
                                  # JSON format — a common way to store structured data as text.
                                  # JSON looks like: {"name":"Buy groceries","done":false}

tasks = []                        # Creates an empty array to hold task hashes.

def add_task(tasks, name)         # Defines add_task — adds a new task hash to the array.
  task = { name: name, done: false }
                                  # Creates a hash with :name and :done keys.
  tasks << task                   # Appends the hash to the tasks array.
end                               # Closes add_task.

def list_tasks(tasks)             # Defines list_tasks to display all tasks.
  tasks.each do |task|            # Loops through each task hash in the array.
    status = task[:done] ? "✓" : " "
                                  # Shows "✓" if done, " " if not.
    puts "[#{status}] #{task[:name]}"
                                  # Prints each task with its checkbox.
  end                             # Closes the loop.
end                               # Closes list_tasks.

def complete_task(tasks, name)    # Defines complete_task — marks a task done by name.
  tasks.each do |task|            # Loops through every task.
    if task[:name] == name        # Checks if this task's name matches.
      task[:done] = true          # Sets :done to true if it matches.
    end                           # Closes the if.
  end                             # Closes the loop.
end                               # Closes complete_task.

def save_tasks(tasks)             # Defines a NEW method — saves the tasks array to a file.
  File.write("tasks.json", tasks.to_json)
                                  # tasks.to_json converts the array into a JSON text string.
                                  # File.write creates/overwrites "tasks.json" with that string.
                                  # After this, tasks are saved on disk and survive program restarts.
end                               # Closes save_tasks.

add_task(tasks, "Buy groceries")           # Adds three tasks.
add_task(tasks, "Finish portfolio project")
add_task(tasks, "Call the bank")

complete_task(tasks, "Buy groceries")      # Marks "Buy groceries" as done.

list_tasks(tasks)                 # Displays all tasks in the terminal.
save_tasks(tasks)                 # Saves everything to tasks.json on disk.
