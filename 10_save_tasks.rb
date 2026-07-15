
require "json"

tasks = []

def add_task(tasks, name)
  task = { name: name, done: false }
  tasks << task
end

def list_tasks(tasks)
  tasks.each do |task|
    status = task[:done] ? "✓" : " "
    puts "[#{status}] #{task[:name]}"
  end
end

def complete_task(tasks, name)
  tasks.each do |task|
    if task[:name] == name
      task[:done] = true
    end
  end
end

def save_tasks(tasks)
  File.write("tasks.json", tasks.to_json)
end

add_task(tasks, "Buy groceries")
add_task(tasks, "Finish portfolio project")
add_task(tasks, "Call the bank")

complete_task(tasks, "Buy groceries")

list_tasks(tasks)
save_tasks(tasks)

