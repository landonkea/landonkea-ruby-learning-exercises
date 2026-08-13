# RELEASING.md

This repo has no server, so "dev / staging / prod" doesn't really apply.
What it has instead is versioned snapshots: git tags that mark "this is
what the lesson set looked like on this date," some marked stable, some
marked as previews. This doc covers how those get made.

## Branches

- **`main`** is the stable branch. Whatever's on `main` should run
  without errors and pass CI (`ruby -c` against every `.rb` file, plus
  the AI-attribution check).
- **`dev`** is where the next batch of lessons lands before it's
  considered done. It doesn't need to be perfect; it needs to not be
  broken for long.
- **Short-lived lesson branches**, named after the lesson
  (`17-enumerable`, `18-priority-and-due-date`, matching the pattern
  already used for lessons 01 through 16), branch off `dev`, get merged
  back into `dev` via PR, and disappear once merged.

When a batch of lessons on `dev` is solid, open a PR from `dev` into
`main`. That merge is what gets tagged.

## Version numbers

Plain [semver](https://semver.org)-shaped tags: `v1.0.0`, `v1.1.0`,
`v2.0.0`. For this repo:

- The **major** number bumps when the task manager's underlying storage
  changes in a way that makes old lessons obsolete, the same kind of
  jump that happened going from JSON files (lesson 10-12) to SQLite
  (lesson 16).
- The **minor** number bumps when new lessons are added without
  breaking the old ones, the normal case.
- The **patch** number bumps for a fix to an existing lesson, like the
  `16_database.rb` `CREATE TABLE` bug fix.

`v1.0.0` marks the repo as it stood after lesson 16 plus the comment
pass, bug fix, and em-dash cleanup, the "core task manager path is done
and correct" milestone. It's tagged locally in this repo already.

## Pre-releases

A tag with a hyphen suffix is a pre-release: `v1.1.0-beta.1`,
`v1.1.0-rc.1`. Push one of those (from `dev`, before it's merged to
`main`, or from `main` if you want to preview a change before calling it
stable) and `.github/workflows/release.yml` creates a GitHub Release
marked as a pre-release, with auto-generated notes from the commits
since the last tag.

## Stable releases

A tag with no hyphen, `v1.1.0`, is stable. Push it from `main` and the
same workflow creates a normal (non-pre-release) GitHub Release.

## How to actually cut one

```bash
git checkout main
git pull

# syntax-check everything first, same check CI runs
find . -name "*.rb" -print0 | xargs -0 -n1 ruby -c

git tag v1.1.0-beta.1
git push origin v1.1.0-beta.1
# ... once it looks right ...
git tag v1.1.0
git push origin v1.1.0
```

Pushing the tag is what triggers `.github/workflows/release.yml`. It
re-runs the syntax check as a gate, figures out from the tag name
whether it's a pre-release or stable, and creates the GitHub Release
with `gh release create --generate-notes`, so the release notes are
just "here's what changed since the last tag" without anyone writing
them by hand.
