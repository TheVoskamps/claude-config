# Git Workflow

## Stay within your repo

You should be run from the root of a repo. Verify with
`git rev-parse --show-toplevel` if unsure; if the starting CWD is not a
repo root, tell the user rather than guessing.

`cd` freely to any path at or below the repo root — subdirectories,
worktrees under `.claude/worktrees/`, and back again.

## Anchor absolute paths to the checkout you are in

Derive every absolute path you hand a file tool from
`git rev-parse --show-toplevel`, never from a repo path you carried in
from a prompt, an environment block, or your own memory.

## Commit messages

- First line: present-tense imperative verb and summary (e.g. "Add
  Lambda for account creation"); keep under 72 characters.
- Blank line.
- Detailed body: wrap at 132 characters; explain what and why, not
  how.
- Commit incrementally — small, focused commits rather than one large
  catch-all commit.

Pass a multi-line message from a file — `git commit -F <path>` — and
write that file in a Bash call of its own.

## Commit and push approval

`git commit` and `git push` without a force flag need no advance
approval on a working branch.

After committing and once tests pass, present the summary of changes,
the files modified with line counts, the proposed commit message, and
the test results.

Push to a working branch freely. Pushing to the **default branch**
requires approval unless the user already asked for it explicitly:
show the commit, say plainly that it is on the default branch, ask
"Do you want me to push this to `origin/{branch}`?", and wait for a
yes.

`--force`, `-f`, and `--mirror` on a push each require explaining why
and getting explicit permission first. `--force-with-lease` and
`--force-if-includes` are fine without it, e.g. after rebasing a branch
onto the default branch's HEAD.
