
require "json"

def add_task(tasks, name)
  task = { name: name, done: false }
  tasks << task
end

def list_tasks(tasks)
  tasks.each_with_index do |task, i|
    status = task[:done] ? "✓" : " "
    puts "#{i + 1}. [#{status}] #{task[:name]}"
  end
end

def complete_task(tasks, index)
  tasks[index][:done] = true
end

def uncomplete_task(tasks, index)
  tasks[index][:done] = false
end

def edit_task(tasks, index, new_name)
  tasks[index][:name] = new_name
end

def delete_task(tasks, index)
  tasks.delete_at(index)
end

def save_tasks(tasks)
  File.write("tasks.json", JSON.pretty_generate(tasks))
end

def load_tasks
  if File.exist?("tasks.json")
    content = File.read("tasks.json")
    JSON.parse(content, symbolize_names: true)
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
    add_task(tasks, name)
    save_tasks(tasks)
  elsif choice == "2"
    list_tasks(tasks)
  elsif choice == "3"
    list_tasks(tasks)
    print "Which task number to complete? "
    index = gets.chomp.to_i - 1
    complete_task(tasks, index)
    save_tasks(tasks)
  elsif choice == "4"
    list_tasks(tasks)
    print "Which task number to mark incomplete? "
    index = gets.chomp.to_i - 1
    uncomplete_task(tasks, index)
    save_tasks(tasks)
  elsif choice == "5"
    list_tasks(tasks)
    print "Which task number to edit? "
    index = gets.chomp.to_i - 1
    print "New name: "
    new_name = gets.chomp
    edit_task(tasks, index, new_name)
    save_tasks(tasks)
  elsif choice == "6"
    list_tasks(tasks)
    print "Which task number to delete? "
    index = gets.chomp.to_i - 1
    delete_task(tasks, index)
    save_tasks(tasks)
  elsif choice == "7"
    break
  else
    puts "Invalid option, try again."
  end
end
