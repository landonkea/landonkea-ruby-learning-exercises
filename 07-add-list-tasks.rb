
tasks = []
def add_task(tasks, task_name)
  tasks << task_name
end

def list_tasks(tasks)
  tasks.each do |task|
    puts "- #{task}"
  end
end
add_task(tasks, "Buy groceries")
add_task(tasks, "Finish portfolio project")
add_task(tasks, "Call the bank")
list_tasks(tasks)
