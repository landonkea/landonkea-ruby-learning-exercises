# ============================================================
# FILE: 12_edit_and_delete.rb
# PURPOSE: Full task manager, add, list, complete, edit, delete.
# CONCEPTS: all previous concepts + editing hashes, deleting from arrays
# ============================================================

require "json"                    # Loads the JSON library for file I/O.

def add_task(tasks, name)         # Defines add_task, creates and appends a task hash.
  task = { name: name, done: false }
                                  # Hash with :name (the text) and :done (starts false).
  tasks << task                   # Appends to the tasks array.
end                               # Closes add_task.

def list_tasks(tasks)             # Defines list_tasks, displays all tasks numbered.
  tasks.each_with_index do |task, i|
                                  # Loops with both the task hash and its index (position).
    status = task[:done] ? "✓" : " "
                                  # Ternary: "✓" if done, " " if not.
    puts "#{i + 1}. [#{status}] #{task[:name]}"
                                  # Prints: "1. [ ] Buy groceries" (human-friendly numbering).
  end                             # Closes the loop.
end                               # Closes list_tasks.

def complete_task(tasks, index)   # Marks a task as done by index.
  tasks[index][:done] = true      # Sets :done to true on the task at that position.
end                               # Closes complete_task.

def uncomplete_task(tasks, index) # Marks a task as NOT done by index.
  tasks[index][:done] = false     # Sets :done back to false.
end                               # Closes uncomplete_task.

def edit_task(tasks, index, new_name)
                                  # Defines edit_task, changes a task's name.
  tasks[index][:name] = new_name  # Accesses the task at "index" and replaces :name with new_name.
end                               # Closes edit_task.

def delete_task(tasks, index)     # Defines delete_task, removes a task from the array.
  tasks.delete_at(index)          # ".delete_at" removes the item at the given position.
                                  # The array shrinks, everything after shifts down by one.
end                               # Closes delete_task.

def save_tasks(tasks)             # Saves tasks to disk as JSON.
  File.write("tasks.json", JSON.pretty_generate(tasks))
                                  # Converts to formatted JSON and writes to tasks.json.
end                               # Closes save_tasks.

def load_tasks                    # Loads tasks from disk when the program starts.
  if File.exist?("tasks.json")    # Checks if the saved file exists.
    content = File.read("tasks.json")
                                  # Reads the file contents as a string.
    JSON.parse(content, symbolize_names: true)
                                  # Converts JSON string back to Ruby array of hashes.
  else                            # No file found (first run).
    []                            # Returns an empty array.
  end                             # Closes the if/else.
end                               # Closes load_tasks.

tasks = load_tasks               # Loads saved tasks (or starts empty).

loop do                           # Infinite loop for the interactive menu.
  puts "\n1. Add task"            # Menu option 1.
  puts "2. List tasks"            # Menu option 2.
  puts "3. Mark task complete"    # Menu option 3.
  puts "4. Mark task incomplete"  # Menu option 4.
  puts "5. Edit task"             # Menu option 5 (NEW in this file).
  puts "6. Delete task"           # Menu option 6 (NEW in this file).
  puts "7. Quit"                  # Menu option 7.
  print "Choose an option: "      # Prompts for input without a newline.
  choice = gets.chomp             # Reads the user's choice.

  if choice == "1"                # Add a new task.
    print "Task name: "           # Asks for the task name.
    name = gets.chomp             # Reads input.
    add_task(tasks, name)         # Adds to the array.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "2"             # List all tasks.
    list_tasks(tasks)             # Displays them.
  elsif choice == "3"             # Mark a task complete.
    list_tasks(tasks)             # Shows tasks with numbers.
    print "Which task number to complete? "
                                  # Asks which one.
    index = gets.chomp.to_i - 1   # Converts to 0-based index.
    complete_task(tasks, index)   # Marks it done.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "4"             # Mark a task incomplete.
    list_tasks(tasks)             # Shows tasks.
    print "Which task number to mark incomplete? "
                                  # Asks which one.
    index = gets.chomp.to_i - 1   # Converts to 0-based index.
    uncomplete_task(tasks, index) # Marks it not done.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "5"             # Edit a task (NEW).
    list_tasks(tasks)             # Shows tasks so user can pick by number.
    print "Which task number to edit? "
                                  # Asks which task to rename.
    index = gets.chomp.to_i - 1   # Converts to 0-based index.
    print "New name: "            # Asks for the new task name.
    new_name = gets.chomp         # Reads the new name.
    edit_task(tasks, index, new_name)
                                  # Replaces the old name with the new one.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "6"             # Delete a task (NEW).
    list_tasks(tasks)             # Shows tasks so user can pick by number.
    print "Which task number to delete? "
                                  # Asks which task to remove.
    index = gets.chomp.to_i - 1   # Converts to 0-based index.
    delete_task(tasks, index)     # Removes the task from the array.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "7"             # Quit.
    break                         # Exits the loop, program ends.
  else                            # Invalid input.
    puts "Invalid option, try again."
                                  # Tells user to enter a valid number.
  end                             # Closes the if/elsif/else chain.
end                               # Closes the loop.
