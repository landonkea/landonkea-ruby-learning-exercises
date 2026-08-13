# FEATURE_IDEAS.md

Ideas for where this repo goes after `16_database.rb`. The task manager
currently does variables, conditionals, loops, arrays, hashes, methods,
classes, JSON persistence, an interactive menu, error handling, string
validation, and a single-table SQLite database. Everything below builds
on that instead of jumping somewhere unrelated. Roughly ordered easiest
to hardest, but feel free to skip around.

## 1. `17_enumerable.rb` — sort, filter, count without a loop
Swap the manual `.each` loops in `list_tasks` for `sort_by { |t| t[:name] }`,
`select { |t| t[:done] }`, and `count { |t| !t[:done] }`. This is the
natural next step after 16: the same task list, but shown sorted
alphabetically, filtered to just what's left to do, or with a "3 of 7
done" summary line. Concepts: `sort_by`, `select`, `reject`, `count`,
`map`, chaining Enumerable methods.

## 2. `18_priority_and_due_date.rb` — add two more columns
Add `priority` (low/medium/high) and `due_date` to the tasks table, plus
menu options to set them and to sort/filter by them. Introduces Ruby's
`Date` class (`Date.today`, `Date.parse`, date comparison) and gives a
reason to sort by something other than name.

## 3. `19_tags.rb` — many tags per task
A join table (`tasks_tags`, `tags`) so a task can have more than one tag
("errands", "work", "urgent"). First real many-to-many relationship in
the series, and a natural use for `GROUP BY` and a multi-table `SELECT`
with a `JOIN`.

## 4. `20_command_line_args.rb` — skip the menu, use flags
Rebuild the SQLite version so it runs from `ARGV` instead of the
interactive loop: `ruby 20_command_line_args.rb add "Buy milk"`,
`ruby 20_command_line_args.rb list --done`. Everything so far has run
interactively; this is the first exercise where the program does one
thing and exits, which is how most real command-line tools behave.
Concepts: `ARGV`, `OptionParser` (built into Ruby, no gem needed).

## 5. `21_lib_structure.rb` — split one file into three
Pull the `Task` class into `lib/task.rb`, the database logic into
`lib/task_repository.rb`, and leave a thin `21_lib_structure.rb` that
just `require_relative`s both and runs the menu. Every lesson so far has
been a single file; this is the first one that isn't, and it's the
shape every non-trivial Ruby project (including a Rails app) actually
takes.

## 6. `22_blocks_procs_lambdas.rb` — what `do |task| ... end` actually is
A dedicated exercise on blocks, `Proc.new`, `lambda`, and `yield`,
written against a `each_task_summary` method that takes a block. The
series has used `.each do |task| ... end` since lesson 4 without ever
explaining what a block is under the hood. Worth closing that gap
before going further.

## 7. `23_recursion.rb` — factorial, fibonacci, and a countdown
`conversionPoundsAndKilos.rb` already uses recursion once (`get_user_input`
calling itself to reject bad input) but never names it or explains it.
This exercise makes recursion the whole point: factorial, Fibonacci, and
a recursive countdown timer, with a comment explaining the base case and
why it has to exist.

## 8. `24_csv_export.rb` — get tasks out of the database
Add a menu option that writes every task to `tasks.csv` using Ruby's
built-in `CSV` library, and a matching import option that reads a CSV
back in. Useful on its own (open your tasks in a spreadsheet) and a
gentle introduction to a standard library module outside of `JSON` and
`SQLite3`.

## 9. `25_environment_config.rb` — stop hardcoding "tasks.db"
Read the database path, and maybe a `TASK_MANAGER_ENV` value
(development vs. test), from `ENV`, falling back to a sensible default
if the variable isn't set. Small exercise, but it's the first time
config lives outside the source file, which matters the moment you want
a separate database for testing.

## 10. `26_custom_errors.rb` — errors with a name
Define `class TaskNotFoundError < StandardError` and
`class InvalidTaskNameError < StandardError`, raise them from the
repository layer instead of returning `nil`, and rescue them by name in
the menu loop. Lesson 14 introduced `rescue`, but only for Ruby's
built-in `ArgumentError`. This is the step from "catch what Ruby throws"
to "define what your own program throws."

## 11. `27_unit_tests.rb` — a test file instead of typing into the menu
A Minitest (or RSpec, either is fine) suite that exercises `Task#complete`,
`Task#to_h`, and the repository's add/list/delete methods without a
human running the program and reading the output by eye. Every previous
lesson has been verified by hand. This is the point where "did I break
anything" becomes a command instead of a manual click-through, and it
sets up wiring the test suite into `ci.yml` alongside the existing
syntax check.

## 12. `28_password_gate.rb` — a PIN before the menu shows up
Store a SHA-256 hash of a 4-digit PIN (via Ruby's `Digest` library,
never the raw PIN) and require it before the task menu loads. Not real
security, and the exercise should say so in a comment, but it's a first
honest look at hashing versus encryption and why you never store a
password as plain text.

## 13. `29_http_request.rb` — talk to something outside the script
Use `Net::HTTP` (or `open-uri`) to fetch a joke or a quote from a free
public API, parse the JSON response, and print one line. First time
anything in this repo reaches outside the local filesystem. Good
groundwork before attempting a real web app.

## 14. `30_sinatra_task_api.rb` — the task manager over HTTP
A minimal Sinatra app (`gem install sinatra`) with `GET /tasks`,
`POST /tasks`, and `PATCH /tasks/:id/complete`, reusing the same
`Task`/`TaskRepository` classes from lesson 21 instead of rewriting
them. This is the exercise that turns "a script I run in a terminal"
into "a thing with a URL," which matters given the goal of eventually
running everything in this account somewhere other than a laptop.

## 15. `31_rack_test.rb` — test the API without running a server
A Rack::Test suite hitting the Sinatra app from lesson 30, checking
status codes and JSON bodies. Pairs naturally with lesson 27's Minitest
introduction, applied to a web layer instead of plain Ruby objects.

## 16. `32_dockerfile` — package the Sinatra app
A `Dockerfile` that installs the gems and runs the Sinatra app from
lesson 30 with `bundle exec ruby app.rb`, plus a one-line README note on
`docker build` / `docker run`. Doesn't need to be fancy. It's the
missing link between "runs on my machine" and "could run anywhere,"
which is the whole point of having `landonkea-docker` as a sibling repo.

## 17. `33_backup_and_restore.rb` — protect the data for real
A script that copies `tasks.db` to a timestamped backup file before any
destructive operation, plus a restore command that lists available
backups and lets you pick one. Small, practical, and something every
one of the earlier lessons that touches `tasks.db` or `tasks.json` could
have used.

## 18. `34_gemfile_and_bundler.rb` — stop assuming gems are just installed
Add a `Gemfile` pinning `sqlite3`, `sinatra`, and `minitest`, and switch
every relevant lesson's instructions from `gem install X` to
`bundle install`. This one isn't a new script so much as a chore that
makes lessons 16 onward reproducible on a machine that doesn't already
have those gems sitting around globally, which is exactly the kind of
thing that trips up a rebuild from scratch.
