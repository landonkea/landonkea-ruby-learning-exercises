# ============================================================
# FILE: 14_error_handling.rb
# PURPOSE: Handle bad user input gracefully without crashing.
# CONCEPTS: rescue, ArgumentError, Integer(), nil checks, unless
# ============================================================

require "json"                    # Loads the JSON library.

class Task                        # Defines the Task class (same blueprint as file 13).
  attr_accessor :name, :done      # Creates getter/setter methods for :name and :done.

  def initialize(name, done = false)
                                  # Called when Task.new is used. Sets @name and @done.
    @name = name                  # Stores the task name as an instance variable.
    @done = done                  # Stores done status (defaults to false).
  end                             # Closes initialize.

  def complete                    # Marks this task as done.
    @done = true                  # Sets @done to true.
  end                             # Closes complete.

  def uncomplete                  # Marks this task as not done.
    @done = false                 # Sets @done to false.
  end                             # Closes uncomplete.

  def to_h                        # Converts this task to a hash for JSON saving.
    { name: @name, done: @done }  # Returns a hash with the task's data.
  end                             # Closes to_h.

  def display(index)              # Prints this task with its number.
    status = @done ? "✓" : " "   # Shows "✓" if done, " " if not.
    puts "#{index + 1}. [#{status}] #{@name}"
                                  # Prints formatted output.
  end                             # Closes display.
end                               # Closes Task class.

def save_tasks(tasks)             # Saves tasks to disk as formatted JSON.
  data = tasks.map { |task| task.to_h }
                                  # Converts each Task object to a hash.
  File.write("tasks.json", JSON.pretty_generate(data))
                                  # Writes the JSON string to tasks.json.
end                               # Closes save_tasks.

def load_tasks                    # Loads tasks from disk.
  if File.exist?("tasks.json")    # Checks if the file exists.
    content = File.read("tasks.json")
                                  # Reads file contents.
    data = JSON.parse(content, symbolize_names: true)
                                  # Parses JSON into an array of hashes.
    data.map { |item| Task.new(item[:name], item[:done]) }
                                  # Converts each hash back to a Task object.
  else                            # File doesn't exist.
    []                            # Returns empty array.
  end                             # Closes if/else.
end                               # Closes load_tasks.

def get_valid_index(tasks, prompt)
                                  # Defines a helper method for safe input handling.
                                  # This prevents crashes from bad user input (letters, negative numbers, etc.).
  print prompt                    # Displays the prompt text (e.g., "Which task number to complete? ").
  input = gets.chomp              # Reads user input and removes trailing newline.
  index = Integer(input) - 1      # "Integer()" tries to convert the string to a number.
                                  # If input is "abc", it raises an ArgumentError, caught by rescue below.
                                  # Subtract 1 to convert from human numbering (1-based) to array index (0-based).
  if index < 0 || index >= tasks.length
                                  # Checks if the index is out of bounds, negative or too large.
    puts "That task number doesn't exist."
                                  # Tells the user the number is invalid.
    return nil                    # Returns nil (Ruby's "nothing" value) to signal failure.
  end                             # Closes the bounds check.
  index                           # If all checks pass, returns the valid 0-based index.
rescue ArgumentError              # "rescue" catches errors. ArgumentError happens when Integer() fails.
                                  # If the user typed "hello" instead of a number, we land here.
  puts "That's not a valid number."
                                  # Friendly error message instead of a crash.
  nil                             # Returns nil to signal the caller that input was bad.
end                               # Closes get_valid_index.

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

  if choice == "1"                # Add a task.
    print "Task name: "           # Asks for the name.
    name = gets.chomp             # Reads input.
    tasks << Task.new(name)       # Creates a new Task and appends it.
    save_tasks(tasks)             # Saves to disk.
  elsif choice == "2"             # List tasks.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Displays all tasks.
  elsif choice == "3"             # Mark complete.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks with numbers.
    index = get_valid_index(tasks, "Which task number to complete? ")
                                  # Uses the safe input method, returns nil if input was bad.
    unless index.nil?             # "unless nil?" means "if it's NOT nil", input was valid.
      tasks[index].complete       # Marks the task as done.
      save_tasks(tasks)           # Saves to disk.
    end                           # Closes the unless block.
  elsif choice == "4"             # Mark incomplete.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks.
    index = get_valid_index(tasks, "Which task number to mark incomplete? ")
                                  # Safe input handling.
    unless index.nil?             # Only proceeds if input was valid.
      tasks[index].uncomplete     # Marks as not done.
      save_tasks(tasks)           # Saves to disk.
    end                           # Closes unless.
  elsif choice == "5"             # Edit task.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks.
    index = get_valid_index(tasks, "Which task number to edit? ")
                                  # Safe input handling.
    unless index.nil?             # Only if valid.
      print "New name: "          # Asks for new name.
      new_name = gets.chomp       # Reads new name.
      tasks[index].name = new_name # Sets the task's name.
      save_tasks(tasks)           # Saves to disk.
    end                           # Closes unless.
  elsif choice == "6"             # Delete task.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks.
    index = get_valid_index(tasks, "Which task number to delete? ")
                                  # Safe input handling.
    unless index.nil?             # Only if valid.
      tasks.delete_at(index)      # Removes the task.
      save_tasks(tasks)           # Saves to disk.
    end                           # Closes unless.
  elsif choice == "7"             # Quit.
    break                         # Exits the loop.
  else                            # Invalid menu option.
    puts "Invalid option, try again."
                                  # Tells user to try again.
  end                             # Closes if/elsif/else.
end                               # Closes loop.
