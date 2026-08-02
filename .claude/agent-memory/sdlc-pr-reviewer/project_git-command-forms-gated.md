---
name: git-command-forms-gated
description: This repo's harness rejects git -C, git args built from command substitution, and xargs piping into git; use bare literal git commands from the worktree cwd, and compare against origin/main because the local main ref in a worktree is often stale.
metadata:
  type: project
---

# Git command forms gated in the worktree sandbox

In this repo's worktree sandbox, three git invocation shapes are
blocked by the harness before they run: `git -C <abs-path> <cmd>`
("forbidden form"), any `git` call whose arguments contain a command
substitution or unresolved variable (cannot be statically classified),
and feeding git its arguments via `xargs`/`parallel` (target repo
unverifiable). Each rejection costs a wasted tool call.

**Why:** worktree-isolated agents' git operations must be statically
verifiable as targeting their own worktree; dynamic tokens defeat the
gate.

**How to apply:** run bare `git <subcommand>` with literal arguments
from the worktree cwd (cwd persists across Bash calls here despite
the agent-definition warning). Resolve intermediate values (e.g.
`git merge-base` output) in one call, then paste the literal SHA into
the next. Also: a worktree's local `main` ref is routinely stale even
after `git fetch` — diff and merge-base against `origin/main` or the
branch's actual fork parent, never local `main`, or the base looks
wrong (see [[adjudicate-count-words-before-flagging]] for the other
standing review lesson).
