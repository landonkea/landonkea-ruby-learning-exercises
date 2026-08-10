# ============================================================
# FILE: 07-add-list-tasks.rb
# PURPOSE: A simple task list, add tasks and display them.
# CONCEPTS: arrays, push (<<), methods with multiple parameters, .each
# ============================================================

tasks = []                        # Creates an empty array called "tasks".
                                  # The [] means "nothing here yet", we'll fill it as we go.

def add_task(tasks, task_name)    # Defines a method that takes TWO inputs: the list and a task name.
                                  # "tasks" is the array to add to, "task_name" is the new task string.
  tasks << task_name              # "<<" is the push operator, it adds task_name to the END of the array.
                                  # This modifies the original array (it does NOT create a new one).
end                               # Closes the add_task method.

def list_tasks(tasks)             # Defines a method to display all tasks. Takes the array as input.
  tasks.each do |task|            # ".each" loops through every item in the tasks array.
                                  # On each pass, "|task|" holds the current task string.
    puts "- #{task}"              # Prints each task with a dash prefix for visual formatting.
  end                             # Closes the .each loop.
end                               # Closes the list_tasks method.

add_task(tasks, "Buy groceries")           # Calls add_task, adds "Buy groceries" to the tasks array.
add_task(tasks, "Finish portfolio project") # Adds a second task to the array.
add_task(tasks, "Call the bank")           # Adds a third task.

list_tasks(tasks)                 # Calls list_tasks, prints all three tasks to the terminal.
