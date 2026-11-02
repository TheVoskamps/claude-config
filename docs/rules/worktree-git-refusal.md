# Worktree Git Refusal

Read this file when a Bash call is refused with "this command names git
in a form too complex to verify that it stays inside the worktree".

The refusal is the upstream bug anthropics/claude-code#100806. This
file is removed once that bug is fixed or once auto mode is dropped in
favour of guardrails.

## What triggers it

In a worktree-isolated session, the Bash tool refuses a command whose
text holds the letters `git` anywhere — a command name, a path such as
`plugins/git-tools/bin/git-branch-sync`, a word such as `legit`, heredoc
text — together with a construct the check cannot read: a loop, a
`$(…)` substitution, `$?`, or a heredoc. Whether any `git` runs does not
matter:

| Refused | Runs |
| --- | --- |
| `shellcheck plugins/git-tools/bin/git-branch-sync; echo rc=$?` | `shellcheck plugins/git-tools/bin/git-branch-sync` |

The Bash tool refuses after PreToolUse hooks and the auto-mode
classifier have allowed the call, so no hook or permission rule lets
the command through.

## The remedy

Split the refused command into separate plain calls, one invocation
per call with literal operands. Where a value came from a `git`
command, run that command in a call of its own and write its output
into the next call as a literal operand.

Rewording to avoid the letters `git` is not the remedy: the letters
come back with the next path or word that holds them, and the
construct is what the check cannot read.
