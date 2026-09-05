# Git Workflow

## Stay within your repo

You should be run from the root of a repo. Verify with
`git rev-parse --show-toplevel` if unsure; if the starting CWD is not a
repo root, tell the user rather than guessing.

`cd` freely to any path at or below the repo root — subdirectories,
worktrees under `.claude/worktrees/`, and back again. What you may
write outside the repo root is the boundary rule in
`rules/core-principles.md` → "Work autonomously; stop at these edges".

## Anchor absolute paths to the checkout you are in

Derive every absolute path you hand a file tool from
`git rev-parse --show-toplevel`, never from a repo path you carried in
from a prompt, an environment block, or your own memory.

## Shape git commands so the isolation gate can read them

In a subagent worktree the isolation gate judges the command string,
not the paths it resolves to: it refuses an inline
environment-assignment prefix (`GIT_EDITOR=false git …`), a heredoc, an
`&&` chain, and any multi-line script that names `git`. Issue one plain
invocation per git command, and pass long text — a commit message, a PR
body — as a file written with the Write tool: `git commit -F <file>`,
`gh pr create --body-file <file>`.

Where that leaves a claim about git's own behavior untestable, settle
it from `git help` or a single non-mutating command and label what
stays unverified, rather than retrying against the gate.

## Commit messages

- First line: present-tense imperative verb and summary (e.g. "Add
  Lambda for account creation"); keep under 72 characters.
- Blank line.
- Detailed body: wrap at 132 characters; explain what and why.
- Use clear, descriptive commit messages.
- Focus on the "what" and "why", not the "how".
- Commit incrementally — small, focused commits rather than one large
  catch-all commit.

## Commit and push approval

`git commit` and `git push` without a force flag are reversible, so
they fall outside the approval carve-outs in
`rules/core-principles.md` → "Work autonomously; stop at these edges"
and need no advance approval on a working branch.

After committing and once tests pass, present the summary of changes,
the files modified with line counts, the proposed commit message, and
the test results. Everything the user might then want is still
available: more changes via another commit, a reworded message via
`git commit --amend`, a rollback via `git reset --soft HEAD~1` (or
`git reset HEAD~1` to unstage as well).

Push to a working branch freely. Pushing to the **default branch**
requires approval unless the user already asked for it explicitly:
show the commit, say plainly that it is on the default branch, ask
"Do you want me to push this to `origin/{branch}`?", and wait for a
yes.

`--force`, `-f`, and `--mirror` on a push each require explaining why
and getting explicit permission first — they can destroy work that is
not yours. `--force-with-lease` and `--force-if-includes` are fine
without it, e.g. after rebasing a branch onto the default branch's
HEAD, because they refuse to clobber commits you haven't seen.
