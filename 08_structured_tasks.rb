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

add_task(tasks, "Buy groceries")
add_task(tasks, "Finish portfolio project")
add_task(tasks, "Call the bank")

list_tasks(tasks)
