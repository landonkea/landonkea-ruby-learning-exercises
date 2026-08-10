# ============================================================
# FILE: 16_database.rb
# PURPOSE: Store tasks in a real database (SQLite) instead of JSON files.
# CONCEPTS: SQLite3, SQL queries, database tables, primary keys
# ============================================================

require "sqlite3"                 # Loads the sqlite3 gem, a library that lets Ruby talk to SQLite databases.
                                  # SQLite is a lightweight database engine that stores data in a single file.

db = SQLite3::Database.new("tasks.db")
                                  # Creates (or opens) a database file called "tasks.db".
                                  # If it doesn't exist yet, SQLite creates it automatically.
                                  # "db" is now a connection to that database file.

db.results_as_hash = true         # Makes query results come back as hashes (with column names as keys)
                                  # instead of plain arrays. So row["name"] works instead of row[1].

db.execute("CREATE TABLE IF NOT EXISTS tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  done BOOLEAN NOT NULL DEFAULT 0
)")                                # WHY: SQLite.new only opens/creates the .db FILE, it does not create
                                  # any tables inside it. Without this, the very first query below
                                  # (INSERT/SELECT/UPDATE/DELETE) would fail with
                                  # "SQLite3::SQLException: no such table: tasks" on a fresh database.
                                  # "IF NOT EXISTS" makes this safe to run every time the script starts,
                                  # it creates the table once and does nothing on later runs.
                                  # id: auto-incrementing primary key (SQLite's row identifier).
                                  # name: the task text, required (NOT NULL).
                                  # done: 0/1 completion flag, defaults to 0 (not done) for new rows.

def add_task(db, name)            # Defines add_task, inserts a row into the tasks table.
  db.execute("INSERT INTO tasks (name, done) VALUES (?, ?)", [name, 0])
                                  # "db.execute" runs a SQL command on the database.
                                  # INSERT INTO tasks adds a new row to the "tasks" table.
                                  # The (?) are "placeholders", they get filled by the values in [name, 0].
                                  # Using placeholders prevents SQL injection attacks (a security thing).
                                  # The name goes in the "name" column, 0 (false) goes in "done".
end                               # Closes add_task.

def list_tasks(db)                # Defines list_tasks, reads all rows from the database.
  rows = db.execute("SELECT * FROM tasks")
                                  # "SELECT * FROM tasks" fetches ALL columns from ALL rows in the tasks table.
                                  # Returns an array of hashes (because of results_as_hash = true).
  rows.each do |row|              # Loops through each row (hash) returned by the query.
    status = row["done"] == 1 ? "✓" : " "
                                  # In SQLite, booleans are stored as 0 (false) or 1 (true).
                                  # So we check if "done" equals 1 to show "✓", otherwise " ".
    puts "#{row["id"]}. [#{status}] #{row["name"]}"
                                  # Prints: "1. [✓] Buy groceries"
                                  # row["id"] is the database's unique ID for that task (auto-assigned).
  end                             # Closes the loop.
end                               # Closes list_tasks.

def complete_task(db, id)         # Defines complete_task, marks a task done by its database ID.
  db.execute("UPDATE tasks SET done = 1 WHERE id = ?", [id])
                                  # "UPDATE tasks SET done = 1" changes the "done" column to 1 (true).
                                  # "WHERE id = ?" ensures we only update the row with that specific ID.
                                  # Without WHERE, ALL tasks would be marked done!
end                               # Closes complete_task.

def uncomplete_task(db, id)       # Defines uncomplete_task, marks a task as not done.
  db.execute("UPDATE tasks SET done = 0 WHERE id = ?", [id])
                                  # Sets "done" to 0 (false) for the task with that ID.
end                               # Closes uncomplete_task.

def edit_task(db, id, new_name)   # Defines edit_task, changes a task's name in the database.
  db.execute("UPDATE tasks SET name = ? WHERE id = ?", [new_name, id])
                                  # Updates the "name" column to new_name for the task with that ID.
end                               # Closes edit_task.

def delete_task(db, id)           # Defines delete_task, removes a task from the database permanently.
  db.execute("DELETE FROM tasks WHERE id = ?", [id])
                                  # "DELETE FROM tasks" removes the row with the matching ID.
                                  # This is permanent, there's no undo in the database!
end                               # Closes delete_task.

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
    name = gets.chomp.strip       # Reads input and removes whitespace with .strip.
    if name == ""                 # Checks if name is empty.
      puts "Task name can't be empty."
                                  # Rejects empty names.
    else                          # Name is valid.
      add_task(db, name)          # Inserts into the database.
    end                           # Closes empty-check.
  elsif choice == "2"             # List tasks.
    list_tasks(db)                # Fetches and displays all rows from the database.
  elsif choice == "3"             # Mark complete.
    list_tasks(db)                # Shows tasks so user can see the IDs.
    print "Which task id to complete? "
                                  # Asks for the database ID (not array index, IDs are permanent).
    id = gets.chomp.to_i          # Reads the ID as an integer.
    complete_task(db, id)         # Updates the database.
  elsif choice == "4"             # Mark incomplete.
    list_tasks(db)                # Shows tasks.
    print "Which task id to mark incomplete? "
                                  # Asks for the ID.
    id = gets.chomp.to_i          # Reads the ID.
    uncomplete_task(db, id)       # Updates the database.
  elsif choice == "5"             # Edit task.
    list_tasks(db)                # Shows tasks.
    print "Which task id to edit? "
                                  # Asks for the ID.
    id = gets.chomp.to_i          # Reads the ID.
    print "New name: "            # Asks for the new name.
    new_name = gets.chomp.strip   # Reads and strips whitespace.
    edit_task(db, id, new_name) unless new_name == ""
                                  # Updates the name, but ONLY if it's not empty.
                                  # "unless" means "if not", the opposite of if.
  elsif choice == "6"             # Delete task.
    list_tasks(db)                # Shows tasks.
    print "Which task id to delete? "
                                  # Asks for the ID.
    id = gets.chomp.to_i          # Reads the ID.
    delete_task(db, id)           # Removes from database permanently.
  elsif choice == "7"             # Quit.
    break                         # Exits the loop.
  else                            # Invalid input.
    puts "Invalid option, try again."
                                  # Tells user to try again.
  end                             # Closes if/elsif/else.
end                               # Closes loop.
