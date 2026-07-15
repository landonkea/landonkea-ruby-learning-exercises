
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
    name = gets.chomp
    tasks << Task.new(name)
    save_tasks(tasks)
  elsif choice == "2"
    tasks.each_with_index { |task, i| task.display(i) }
  elsif choice == "3"
    tasks.each_with_index { |task, i| task.display(i) }
    print "Which task number to complete? "
    index = gets.chomp.to_i - 1
    tasks[index].complete
    save_tasks(tasks)
  elsif choice == "4"
    tasks.each_with_index { |task, i| task.display(i) }
    print "Which task number to mark incomplete? "
    index = gets.chomp.to_i - 1
    tasks[index].uncomplete
    save_tasks(tasks)
  elsif choice == "5"
    tasks.each_with_index { |task, i| task.display(i) }
    print "Which task number to edit? "
    index = gets.chomp.to_i - 1
    print "New name: "
    new_name = gets.chomp
    tasks[index].name = new_name
    save_tasks(tasks)
  elsif choice == "6"
    tasks.each_with_index { |task, i| task.display(i) }
    print "Which task number to delete? "
    index = gets.chomp.to_i - 1
    tasks.delete_at(index)
    save_tasks(tasks)
  elsif choice == "7"
    break
  else
    puts "Invalid option, try again."
  end
end
