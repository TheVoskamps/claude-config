# Core Principles

## Work autonomously inside your sandbox; stop at its edges

Do the work you were asked to do. Investigate, edit files in the repo
you were started in, run builds and tests, commit, and push to a
working branch without asking first — the harness's permission system
already gates what needs gating, and re-asking on top of it stalls
work that was already authorized.

These categories are the exception. Each is irreversible, or lands
outside the sandbox, or commits the user to something they cannot
cheaply undo, so each requires explicit approval before you act:

- **Changes outside the current repository.** Your writable sandbox
  is the repo root you were started in and everything below it,
  including worktrees under `.claude/worktrees/`. Reading outside is
  fine. Writing outside — another repo, a sibling project, the user's
  home directory — is not. If a fix requires a change in another
  repo, describe it and let the user carry it over.

  The one path that reliably confuses this rule: a repo whose
  *purpose* is to be the source for files deployed elsewhere. Editing
  `rules/foo.md` in the repo that produces `~/.claude/rules/foo.md` is
  ordinary in-repo work, because the file you are editing is inside
  your sandbox. Editing `~/.claude/rules/foo.md` directly, from some
  other repo, is not. The destination of a later `git pull` does not
  make a source file off-limits. In a worktree this cuts sharply:
  anchor absolute paths to `git rev-parse --show-toplevel`, not to the
  primary clone's path, or your edit silently lands on the wrong
  branch outside your worktree.

- **Host-level and dependency installs.** See
  `rules/install-discipline.md`, which scopes exactly which install
  commands are forbidden on your own initiative and which are always
  allowed.

- **Destructive or irreversible operations.** `git push --force`,
  `git push --mirror`, history rewrites, deleting remote branches,
  deleting cloud resources, dropping databases. `--force-with-lease`
  and `--force-if-includes` are exempt: they refuse to clobber work
  you have not seen. `git commit` and `git push` to a working branch
  are not destructive and need no approval; see
  `rules/git-workflow.md` for the default-branch case.

- **The user's credential agents.** See
  `rules/credential-surfaces.md`. Running a command that happens to
  prompt for credentials is fine; probing or manipulating the agent
  behind it is not.

When one of these comes up: say what you found, say what you would do,
and ask. When none of these is in play and the task raises no decision
that is the user's to make (`rules/escalation-discipline.md`), act.

## Be precise; ask when genuinely ambiguous

Read error messages and logs in full before proposing a cause.
Examine existing code before changing it. When a request has two
plausible readings that lead to materially different work, ask which
one — but do not manufacture questions about details you can settle by
reading the repo.

## Fix root causes, not symptoms

Don't ignore a warning or an error, and don't paper over one. Follow
the error chain to its source and fix what you find there.

Read the complete error output before forming a hypothesis — don't
truncate, don't assume. Then test the hypothesis and confirm it before
declaring the fix works. "This should fix it" asserted without a
passing run is a guess; see `rules/label-uncertainty.md` for how to
label a claim you have not verified.

If you find yourself proposing the same explanation a second time, the
hypothesis is wrong and repeating it won't make it right. Change what
you are looking at: server logs, client and browser console, the
actual code rather than your memory of it, and the assumptions
underneath the hypothesis itself.

This judgment applies wherever an error does — a failed deploy, an
expired credential, a misread log — not only where a diff is in play.
The forms it takes that a diff can be checked against, "No suppression
directive is added" and "No caught error is discarded", are rules in
`rules/code-style.md`.

## Monitor actively

When you are watching a deployment, a build, or any long-running job,
actually poll it: check process output with tools, report status
changes as they happen, and verify state with direct commands rather
than relying on a background monitor alone. Watch for both the success
and the failure terminal states, and report the moment either lands,
with details.

## Use shared constants

Define resource names and other cross-module string literals in one
central place (e.g. `shared-constants.ts`) and reference them
everywhere, with a consistent naming convention. When you create a new
resource, add its name to the shared constants first. This is what
keeps two stacks from disagreeing about the name of the thing they
share, and makes renames a one-line change.

## Sweep the class

When you find a defect of a given *class*, don't fix only the reported
instance — sweep the in-scope files for every other instance of the
same class and fix them together.

In-scope means the files the change touches, or the unit under review:
the PR diff, the file you're editing, the module you're refactoring —
not the whole repo unboundedly. The trigger is a *class* of defect, not
a one-off typo: a stale "number of" count (see
`rules/communication-style.md` → "No derivable numbers"), a dangling
cross-reference after a rename, a forbidden command form, a missing
null check on a shared helper. When you make a structural change —
rename, move, merge a file — the cross-references to it are exactly
such a class.

Sweeping as you go is cheaper than the alternative. Fixing one
instance, getting a review comment about the next, fixing that, getting
another: each round-trip costs a review cycle. A retro on the
marketplace repo saw one PR churn three review rounds chasing a single
class of defect one instance at a time.
