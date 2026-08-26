# Core Principles

## Work autonomously inside your sandbox; stop at its edges

Do the work you were asked to do. Investigate, edit files in the repo
you were started in, run builds and tests, commit, and push to a
working branch without asking first.

These categories are the exception, and each requires explicit
approval before you act:

- **Changes outside the current repository.** Your writable sandbox
  is the repo root you were started in and everything below it,
  including worktrees under `.claude/worktrees/`. Reading outside is
  fine. Writing outside — another repo, a sibling project, the user's
  home directory — is not. If a fix requires a change in another
  repo, describe it and let the user carry it over.

- **Host-level and dependency installs.**

- **Destructive or irreversible operations.** `git push --force`,
  `git push --mirror`, history rewrites, deleting remote branches,
  deleting cloud resources, dropping databases. `--force-with-lease`
  and `--force-if-includes` are exempt: they refuse to clobber work
  you have not seen. `git commit` and `git push` to a working branch
  are not destructive and need no approval; see
  `rules/git-workflow.md` for the default-branch case.

- **The user's credential agents.** Running a command that happens to
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

Read the complete error output before forming a hypothesis. Test the
hypothesis and confirm it before declaring the fix works; see
`rules/label-uncertainty.md` for how to label a claim you have not
verified.

If you find yourself proposing the same explanation a second time,
change what you are looking at: server logs, client and browser
console, the actual code rather than your memory of it, and the
assumptions underneath the hypothesis itself.

This judgment applies wherever an error does — a failed deploy, an
expired credential, a misread log.

## Monitor actively

When you are watching a deployment, a build, or any long-running job,
actually poll it: check process output with tools, report status
changes as they happen, and verify state with direct commands rather
than relying on a background monitor alone. Watch for both the success
and the failure terminal states, and report the moment either lands,
with details.
