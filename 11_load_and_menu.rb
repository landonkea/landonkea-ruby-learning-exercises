# ============================================================
# FILE: 11_load_and_menu.rb
# PURPOSE: Load saved tasks + interactive menu to manage them.
# CONCEPTS: File.exist?, File.read, JSON.parse, loop, case-style if/elsif
# ============================================================

require "json"                    # Loads the JSON library for reading/writing JSON data.

def add_task(tasks, name)         # Defines add_task — creates a task hash and appends it.
  task = { name: name, done: false }
                                  # Hash with :name (string) and :done (boolean, starts false).
  tasks << task                   # Pushes the hash onto the tasks array.
end                               # Closes add_task.

def list_tasks(tasks)             # Defines list_tasks with numbered output.
  tasks.each_with_index do |task, i|
                                  # ".each_with_index" is like .each but also gives you the position (index).
                                  # First pass: task = first hash, i = 0. Second: task = second hash, i = 1.
    status = task[:done] ? "✓" : " "
                                  # Shows "✓" if done, " " if not.
    puts "#{i + 1}. [#{status}] #{task[:name]}"
                                  # Prints numbered task: "1. [✓] Buy groceries"
                                  # i + 1 because humans count from 1, but arrays start at 0.
  end                             # Closes the loop.
end                               # Closes list_tasks.

def complete_task(tasks, index)   # Marks a task done by its INDEX (position number).
  tasks[index][:done] = true      # Accesses the task at position "index" and sets :done to true.
end                               # Closes complete_task.

def uncomplete_task(tasks, index) # Marks a task as NOT done by its index.
  tasks[index][:done] = false     # Sets :done back to false.
end                               # Closes uncomplete_task.

def save_tasks(tasks)             # Saves the tasks array to a JSON file on disk.
  File.write("tasks.json", JSON.pretty_generate(tasks))
                                  # JSON.pretty_generate converts the array to nicely formatted JSON
                                  # (with indentation). File.write writes it to "tasks.json".
end                               # Closes save_tasks.

def load_tasks                    # Defines load_tasks — reads tasks from disk when the program starts.
  if File.exist?("tasks.json")    # Checks if the file "tasks.json" exists on disk.
                                  # If the file doesn't exist yet, we skip to else and return an empty list.
    content = File.read("tasks.json")
                                  # Reads the entire file contents into a string variable.
    JSON.parse(content, symbolize_names: true)
                                  # Converts the JSON string back into a Ruby array of hashes.
                                  # symbolize_names: true makes keys symbols (:name) instead of strings ("name").
  else                            # If the file doesn't exist (first time running)...
    []                            # ...return an empty array — no saved tasks yet.
  end                             # Closes the if/else.
end                               # Closes load_tasks.

tasks = load_tasks               # Loads any previously saved tasks. Empty array if first run.

loop do                           # "loop do" starts an infinite loop — repeats until "break" is hit.
  puts "\n1. Add task"            # "\n" adds a blank line before the menu for readability.
  puts "2. List tasks"            # Displays menu option 2.
  puts "3. Mark task complete"    # Displays menu option 3.
  puts "4. Mark task incomplete"  # Displays menu option 4.
  puts "5. Quit"                  # Displays menu option 5.
  print "Choose an option: "      # "print" (not puts) keeps the cursor on the same line for input.
  choice = gets.chomp             # Reads the user's menu choice and stores it as a string.

  if choice == "1"                # User chose to add a task.
    print "Task name: "           # Asks for the task name.
    name = gets.chomp             # Reads the task name from input.
    add_task(tasks, name)         # Adds the task to the array.
    save_tasks(tasks)             # Saves to disk immediately so it's not lost.
  elsif choice == "2"             # User chose to list tasks.
    list_tasks(tasks)             # Displays all tasks.
  elsif choice == "3"             # User chose to mark a task complete.
    list_tasks(tasks)             # Shows tasks so they can see the numbers.
    print "Which task number to complete? "
                                  # Asks which task to mark done.
    index = gets.chomp.to_i - 1   # Reads the number, converts to integer with .to_i,
                                  # subtracts 1 to convert from human (1-based) to array (0-based) index.
    complete_task(tasks, index)   # Marks that task as done.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "4"             # User chose to mark a task incomplete.
    list_tasks(tasks)             # Shows the tasks.
    print "Which task number to mark incomplete? "
                                  # Asks which task to un-complete.
    index = gets.chomp.to_i - 1   # Converts input to 0-based index.
    uncomplete_task(tasks, index) # Sets :done back to false.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "5"             # User chose to quit.
    break                         # "break" exits the loop — the program ends.
  else                            # User typed something invalid (not 1-5).
    puts "Invalid option, try again."
                                  # Tells them to try a valid number.
  end                             # Closes the if/elsif/else chain.
end                               # Closes the loop do.

