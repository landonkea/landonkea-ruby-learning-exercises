# ============================================================
# FILE: 15_string_methods.rb
# PURPOSE: Add input validation using string methods (.strip, empty?).
# CONCEPTS: .strip, .empty?, preventing empty task names
# ============================================================


require "json"                    # Loads the JSON library for saving/loading data.

class Task                        # Defines the Task class blueprint.
  attr_accessor :name, :done      # Getter/setter methods for :name and :done.

  def initialize(name, done = false)
                                  # Called on Task.new. Sets initial values.
    @name = name                  # Stores the task name.
    @done = done                  # Stores done status (defaults to false).
  end                             # Closes initialize.

  def complete                    # Instance method to mark done.
    @done = true                  # Sets @done to true.
  end                             # Closes complete.

  def uncomplete                  # Instance method to mark not done.
    @done = false                 # Sets @done to false.
  end                             # Closes uncomplete.

  def to_h                        # Converts this task to a hash for JSON.
    { name: @name, done: @done }  # Returns hash with task data.
  end                             # Closes to_h.

  def display(index)              # Prints this task with its number.
    status = @done ? "✓" : " "   # Shows status symbol.
    puts "#{index + 1}. [#{status}] #{@name}"
                                  # Prints formatted task.
  end                             # Closes display.
end                               # Closes Task class.

def save_tasks(tasks)             # Saves tasks to disk as JSON.
  data = tasks.map { |task| task.to_h }
                                  # Converts Task objects to hashes.
  File.write("tasks.json", JSON.pretty_generate(data))
                                  # Writes formatted JSON to tasks.json.
end                               # Closes save_tasks.

def load_tasks                    # Loads tasks from disk.
  if File.exist?("tasks.json")    # Checks if saved file exists.
    content = File.read("tasks.json")
                                  # Reads file contents.
    data = JSON.parse(content, symbolize_names: true)
                                  # Parses JSON to array of hashes.
    data.map { |item| Task.new(item[:name], item[:done]) }
                                  # Converts hashes to Task objects.
  else                            # No file found.
    []                            # Returns empty array.
  end                             # Closes if/else.
end                               # Closes load_tasks.

def get_valid_index(tasks, prompt)
                                  # Safe input handler, prevents crashes from bad input.
  print prompt                    # Displays the question.
  input = gets.chomp              # Reads user input.
  index = Integer(input) - 1      # Converts to integer, adjusts to 0-based index.
                                  # Integer() raises ArgumentError if input isn't a number.
  if index < 0 || index >= tasks.length
                                  # Checks if index is out of range.
    puts "That task number doesn't exist."
                                  # Friendly error message.
    return nil                    # Returns nil to signal failure.
  end                             # Closes bounds check.
  index                           # Returns valid index.
rescue ArgumentError              # Catches non-numeric input.
  puts "That's not a valid number."
                                  # Friendly error instead of crash.
  nil                             # Returns nil.
end                               # Closes get_valid_index.

tasks = load_tasks               # Loads saved tasks from disk.

loop do                           # Infinite loop for the menu.
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
    name = gets.chomp.strip       # Reads input AND calls .strip to remove leading/trailing whitespace.
                                  # .strip removes spaces, tabs, and newlines from both ends of the string.
                                  # So "  Buy milk  " becomes "Buy milk".
    if name == ""                 # Checks if the name is empty after stripping whitespace.
                                  # An empty string means the user just pressed Enter or typed spaces.
      puts "Task name can't be empty."
                                  # Tells the user they must provide a name.
    else                          # Name is valid (not empty).
      tasks << Task.new(name)     # Creates a new Task and appends it.
      save_tasks(tasks)           # Saves to disk.
    end                           # Closes the empty-check.
  elsif choice == "2"             # List tasks.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Displays all tasks.
  elsif choice == "3"             # Mark complete.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks with numbers.
    index = get_valid_index(tasks, "Which task number to complete? ")
                                  # Safe input handling.
    unless index.nil?             # Only if input was valid.
      tasks[index].complete       # Marks as done.
      save_tasks(tasks)           # Saves to disk.
    end                           # Closes unless.
  elsif choice == "4"             # Mark incomplete.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks.
    index = get_valid_index(tasks, "Which task number to mark incomplete? ")
                                  # Safe input.
    unless index.nil?             # Only if valid.
      tasks[index].uncomplete     # Marks as not done.
      save_tasks(tasks)           # Saves to disk.
    end                           # Closes unless.
  elsif choice == "5"             # Edit task.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks.
    index = get_valid_index(tasks, "Which task number to edit? ")
                                  # Safe input.
    unless index.nil?             # Only if valid.
      print "New name: "          # Asks for new name.
      new_name = gets.chomp.strip # Reads input and strips whitespace.
                                  # .strip ensures "  " (just spaces) becomes "".
      if new_name == ""           # Checks if the new name is empty.
        puts "Task name can't be empty."
                                  # Rejects empty names.
      else                        # Name is valid.
        tasks[index].name = new_name # Updates the task's name.
        save_tasks(tasks)         # Saves to disk.
      end                         # Closes the empty-check.
    end                           # Closes unless.
  elsif choice == "6"             # Delete task.
    tasks.each_with_index { |task, i| task.display(i) }
                                  # Shows tasks.
    index = get_valid_index(tasks, "Which task number to delete? ")
                                  # Safe input.
    unless index.nil?             # Only if valid.
      tasks.delete_at(index)      # Removes the task from the array.
      save_tasks(tasks)           # Saves to disk.
    end                           # Closes unless.
  elsif choice == "7"             # Quit.
    break                         # Exits the loop.
  else                            # Invalid menu option.
    puts "Invalid option, try again."
                                  # Tells user to try again.
  end                             # Closes if/elsif/else.
end                               # Closes loop.
