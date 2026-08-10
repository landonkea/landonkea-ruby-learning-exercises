# ============================================================
# FILE: 13_classes.rb
# PURPOSE: Organize tasks using a class, a blueprint for task objects.
# CONCEPTS: class, attr_accessor, initialize, instance methods, @instance variables
# ============================================================

require "json"                    # Loads the JSON library for saving/loading data.

class Task                        # "class" defines a blueprint. A Task class means every task object
                                  # has the same structure: a name, a done status, and the same methods.
  attr_accessor :name, :done      # "attr_accessor" auto-creates getter and setter methods for :name and :done.
                                  # This means you can read AND write task.name and task.done from outside.
                                  # Without this, @name and @done would be locked inside the class.

  def initialize(name, done = false)
                                  # "initialize" is a special method called automatically when you create
                                  # a new Task with Task.new("something"). It sets up the object's initial state.
                                  # "done = false" means done is optional, if not provided, it defaults to false.
    @name = name                  # "@name" is an instance variable, it belongs to THIS specific task object.
                                  # It stores the task's name. The @ prefix makes it an instance variable.
    @done = done                  # "@done" stores whether the task is complete. Starts as false by default.
  end                             # Closes initialize.

  def complete                    # Defines an instance method, called on a specific task object.
    @done = true                  # Sets this task's :done to true.
  end                             # Closes complete.

  def uncomplete                  # Defines another instance method.
    @done = false                 # Sets this task's :done back to false.
  end                             # Closes uncomplete.

  def to_h                        # Defines to_h, converts this task object back into a hash.
                                  # We need this because JSON can't save Ruby objects directly,
                                  # but it CAN save hashes.
    { name: @name, done: @done }  # Returns a hash with the task's data. This is called "serialization".
  end                             # Closes to_h.

  def display(index)              # Defines display, prints this task with its number.
    status = @done ? "✓" : " "   # Shows "✓" if done, " " if not.
    puts "#{index + 1}. [#{status}] #{@name}"
                                  # Prints formatted task: "1. [ ] Buy groceries"
  end                             # Closes display.
end                               # Closes the Task class definition.

def save_tasks(tasks)             # Saves an array of Task objects to disk.
  data = tasks.map { |task| task.to_h }
                                  # ".map" transforms each Task object into a hash using to_h.
                                  # The result is an array of hashes, which JSON can handle.
  File.write("tasks.json", JSON.pretty_generate(data))
                                  # Converts to formatted JSON and writes to the file.
end                               # Closes save_tasks.

def load_tasks                    # Loads tasks from disk, returning Task objects.
  if File.exist?("tasks.json")    # Checks if the saved file exists.
    content = File.read("tasks.json")
                                  # Reads the file as a string.
    data = JSON.parse(content, symbolize_names: true)
                                  # Parses JSON into an array of hashes.
    data.map { |item| Task.new(item[:name], item[:done]) }
                                  # ".map" converts each hash back into a Task object.
                                  # Task.new creates a new Task with the saved name and done status.
  else                            # No file found.
    []                            # Returns empty array.
  end                             # Closes the if/else.
end                               # Closes load_tasks.

tasks = load_tasks               # Loads saved tasks from disk.

loop do                           # Infinite loop for the interactive menu.
  puts "\n1. Add task"            # Menu option 1.
  puts "2. List tasks"            # Menu option 2.
  puts "3. Mark task complete"    # Menu option 3.
  puts "4. Mark task incomplete"  # Menu option 4.
  puts "5. Edit task"             # Menu option 5.
  puts "6. Delete task"           # Menu option 6.
  puts "7. Quit"                  # Menu option 7.
  print "Choose an option: "      # Prompts for input.
  choice = gets.chomp             # Reads user choice.

  if choice == "1"                # Add a new task.
    print "Task name: "           # Asks for the task name.
    name = gets.chomp             # Reads input.
    tasks << Task.new(name)       # Creates a NEW Task object and appends it to the array.
                                  # Task.new(name) calls initialize with done = false (the default).
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "2"             # List tasks.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Loops and calls each task's display method with its index.
                                  # This uses a "block" form, concise one-line syntax with {}.
  elsif choice == "3"             # Mark complete.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows all tasks with numbers.
    print "Which task number to complete? "
                                  # Asks which one.
    index = gets.chomp.to_i - 1   # Converts to 0-based index.
    tasks[index].complete         # Calls the complete method on that specific task object.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "4"             # Mark incomplete.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks.
    print "Which task number to mark incomplete? "
                                  # Asks which one.
    index = gets.chomp.to_i - 1   # Converts to 0-based index.
    tasks[index].uncomplete       # Calls uncomplete on that task.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "5"             # Edit a task.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks.
    print "Which task number to edit? "
                                  # Asks which task.
    index = gets.chomp.to_i - 1   # Converts to 0-based index.
    print "New name: "            # Asks for the new name.
    new_name = gets.chomp         # Reads the new name.
    tasks[index].name = new_name  # Uses attr_accessor setter to change the task's name directly.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "6"             # Delete a task.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks.
    print "Which task number to delete? "
                                  # Asks which one.
    index = gets.chomp.to_i - 1   # Converts to 0-based index.
    tasks.delete_at(index)        # Removes the task from the array.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "7"             # Quit.
    break                         # Exits the loop.
  else                            # Invalid input.
    puts "Invalid option, try again."
                                  # Tells user to try again.
  end                             # Closes the if/elsif/else.
end                               # Closes the loop.
