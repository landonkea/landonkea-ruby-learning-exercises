require "sqlite3"

db = SQLite3::Database.new("tasks.db")
db.results_as_hash = true

def add_task(db, name)
  db.execute("INSERT INTO tasks (name, done) VALUES (?, ?)", [name, 0])
end

def list_tasks(db)
  rows = db.execute("SELECT * FROM tasks")
  rows.each do |row|
    status = row["done"] == 1 ? "✓" : " "
    puts "#{row["id"]}. [#{status}] #{row["name"]}"
  end
end

def complete_task(db, id)
  db.execute("UPDATE tasks SET done = 1 WHERE id = ?", [id])
end

def uncomplete_task(db, id)
  db.execute("UPDATE tasks SET done = 0 WHERE id = ?", [id])
end

def edit_task(db, id, new_name)
  db.execute("UPDATE tasks SET name = ? WHERE id = ?", [new_name, id])
end

def delete_task(db, id)
  db.execute("DELETE FROM tasks WHERE id = ?", [id])
end

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
      add_task(db, name)
    end
  elsif choice == "2"
    list_tasks(db)
  elsif choice == "3"
    list_tasks(db)
    print "Which task id to complete? "
    id = gets.chomp.to_i
    complete_task(db, id)
  elsif choice == "4"
    list_tasks(db)
    print "Which task id to mark incomplete? "
    id = gets.chomp.to_i
    uncomplete_task(db, id)
  elsif choice == "5"
    list_tasks(db)
    print "Which task id to edit? "
    id = gets.chomp.to_i
    print "New name: "
    new_name = gets.chomp.strip
    edit_task(db, id, new_name) unless new_name == ""
  elsif choice == "6"
    list_tasks(db)
    print "Which task id to delete? "
    id = gets.chomp.to_i
    delete_task(db, id)
  elsif choice == "7"
    break
  else
    puts "Invalid option, try again."
  end
end
