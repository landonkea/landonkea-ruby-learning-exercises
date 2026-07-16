

require "json"

class Task
  attr_accessor :name, :done

  def initialize(name, done = false)
    @name = name
    @done = done
  end

  def complete
    @done = true
  end

  def uncomplete
    @done = false
  end

  def to_h
    { name: @name, done: @done }
  end

  def display(index)
    status = @done ? "✓" : " "
    puts "#{index + 1}. [#{status}] #{@name}"
  end
end

def save_tasks(tasks)
  data = tasks.map { |task| task.to_h }
  File.write("tasks.json", JSON.pretty_generate(data))
end

def load_tasks
  if File.exist?("tasks.json")
    content = File.read("tasks.json")
    data = JSON.parse(content, symbolize_names: true)
    data.map { |item| Task.new(item[:name], item[:done]) }
  else
    []
  end
end

def get_valid_index(tasks, prompt)
  print prompt
  input = gets.chomp
  index = Integer(input) - 1
  if index < 0 || index >= tasks.length
    puts "That task number doesn't exist."
    return nil
  end
  index
rescue ArgumentError
  puts "That's not a valid number."
  nil
end

tasks = load_tasks

loop do
  puts "\n1. Add task"
  puts "2. List tasks"
  puts "3. Mark task complete"
  puts "4. Mark task incomplete"
  puts "5. Edit task"
  puts "6. Delete task"
  puts "7. Quit"
  print "Choose an option: "
  choice = gets.chomp

  if choice == "1"
    print "Task name: "
    name = gets.chomp.strip
    if name == ""
      puts "Task name can't be empty."
    else
      tasks << Task.new(name)
      save_tasks(tasks)
    end
  elsif choice == "2"
    tasks.each_with_index { |task, i| task.display(i) }
  elsif choice == "3"
    tasks.each_with_index { |task, i| task.display(i) }
    index = get_valid_index(tasks, "Which task number to complete? ")
    unless index.nil?
      tasks[index].complete
      save_tasks(tasks)
    end
  elsif choice == "4"
    tasks.each_with_index { |task, i| task.display(i) }
    index = get_valid_index(tasks, "Which task number to mark incomplete? ")
    unless index.nil?
      tasks[index].uncomplete
      save_tasks(tasks)
    end
  elsif choice == "5"
    tasks.each_with_index { |task, i| task.display(i) }
    index = get_valid_index(tasks, "Which task number to edit? ")
    unless index.nil?
      print "New name: "
      new_name = gets.chomp.strip
      if new_name == ""
        puts "Task name can't be empty."
      else
        tasks[index].name = new_name
        save_tasks(tasks)
      end
    end
  elsif choice == "6"
    tasks.each_with_index { |task, i| task.display(i) }
    index = get_valid_index(tasks, "Which task number to delete? ")
    unless index.nil?
      tasks.delete_at(index)
      save_tasks(tasks)
    end
  elsif choice == "7"
    break
  else
    puts "Invalid option, try again."
  end
end

