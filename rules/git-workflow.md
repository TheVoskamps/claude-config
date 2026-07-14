# Git Workflow

## Stay Within Your Repo

You should be run from the root of a repo. Verify with `git rev-parse
--show-toplevel` if unsure. If the starting CWD is not a repo root, tell
the user — don't guess.

You may freely `cd` to any path **at or below** the repo root,
including:

- subdirectories of the repo
- worktrees under `.claude/worktrees/`
- back to the repo root

You may **not** `cd` outside the repo root without permission. If a fix
requires changes in another repo, suggest the change in the
conversation; don't implement it.

## cwd persists across Bash calls

The working directory **persists across Bash calls** in the main
session. After one bare `cd`, every subsequent command runs in the
new CWD without re-stating it. If the local directory (re)setting is
wrong, tell the user.

> **Subagent / `isolation: worktree` context.** The rules for
> Task-tool subagents — cwd-does-not-persist, the worktree command
> forms, and end-of-run worktree/branch cleanup — live with the
> orchestrator and its agents in the `sdlc` plugin, not here. This
> file covers only the main session.

## Commit Messages

- First line: present-tense imperative verb and summary (e.g. "Add
  Lambda for account creation"); keep under 72 characters.
- Blank line.
- Detailed body: wrap at 132 characters; explain what and why.
- Use clear, descriptive commit messages.
- Focus on the "what" and "why", not the "how".
- Commit incrementally — small, focused commits rather than one large
  catch-all commit.

### Commit Signing

If you get an error on a commit "remote: error: GH006: Protected branch
update failed for refs/heads/main." or "remote: error: Commits must have
verified signatures." or "remote: error: GH013: Repository rule violations
found for refs/heads/main." or "remote: - Commits must have verified
signatures." you need to sign the commit with a signature GitHub can
verify (GPG, S/MIME, or SSH) against a key registered to a GitHub account,
with the committer email matching a verified email on that account.

### Issue References

#### CRITICAL — closing keyword: PR body only, own issue only

GitHub links and auto-closes issues via a closing keyword (`close`,
`closes`, `closed`, `fix`, `fixes`, `fixed`, `resolve`, `resolves`,
`resolved`, case-insensitive) **immediately followed by** an issue
reference (`#N`, `owner/repo#N`, `GH-N`, or
`https://github.com/owner/repo/issues/N`). Per GitHub's "Linking a
pull request to an issue" docs, the keyword behaves differently
depending on *where* it appears:

- **In the PR description**: creates the Development-sidebar "linked
  pull request" **and** auto-closes the linked issue when the PR
  merges into the repository's default branch. This is GitHub's
  sanctioned mechanism for both effects.
- **In a commit message**: auto-closes the issue on merge to default,
  but the containing PR is **not** listed as a linked PR — the sidebar
  link comes from the PR description (or manual linking), not from
  commits. Commit-message placement gets the close without the link,
  and muddies commit history with a repo-wide side effect.
- Keywords are interpreted only when the PR targets the default
  branch.

Because auto-close-on-merge for the branch's own issue is the outcome
we want, and the PR body is the only placement that also produces the
sidebar link, the rule is:

1. **Put a closing keyword in the PR body, referencing the branch's
   own issue.** This is required, not forbidden — it is how the PR
   gets linked in the Development sidebar and how the issue
   auto-closes when the PR merges to the default branch.
2. **Never put a closing keyword in a commit message.** Closing
   keywords belong in the PR body only.
3. **Never aim a closing keyword at any issue other than the branch's
   own issue** — not an umbrella/parent issue, not a predecessor, not
   a "related" issue.

**The branch's own issue** is the issue number the issue-developer was
tasked with when it created the branch. That number is also encoded in
the branch name (convention `issue-<N>-<slug>`). The two normally
agree, but when they don't, **the branch name is the higher-fidelity
source of truth** — the orchestrator itself sometimes performs the
final push and PR creation (e.g. when the issue-developer dies
mid-run), and in that path the branch name is the durable record of
which issue the PR closes.

**What this rule requires:**

- ✅ PR body for the branch's own issue #123: `Closes #123`,
  `Fixes #123`, `Resolves #123` (or another keyword from the list
  above).

**What this rule prohibits:**

- ❌ A closing keyword anywhere in a commit message, e.g.
  `Fixes #123` as a commit trailer — even for the branch's own issue.
- ❌ A closing keyword in the PR body aimed at any issue other than
  the branch's own, e.g. `Closes #100` in the PR body of a branch
  whose own issue is #123.
- ❌ `Closes Dependabot alert #88` — the parser requires nothing
  between the keyword and the `#N`; it discards intervening words like
  "Dependabot alert" and reads this as `Closes #88`, closing issue #88
  itself. This is a trap: the author believes "Dependabot alert" scopes
  the reference, but the syntactic parser does not know what a
  Dependabot alert is — it only sees `<keyword> ... #<N>` and closes
  whatever issue number follows.

**What this rule does NOT prohibit:**

- ✅ The keywords as ordinary English prose with no adjacent issue
  reference: "Dependency tree after fix", "The fix lands in PR #1070",
  "This closes a long-standing gap", "Resolved in production".
- ✅ The keywords inside code blocks, file paths, or identifiers
  (`fix_bug.py`, `def resolve_path()`).

The auto-close parser is purely syntactic — it looks for the
keyword-then-reference pattern. Rewriting "Dependency tree after fix"
to "Dependency tree after patch" is gold-plating, not rule compliance,
and changes the meaning unnecessarily.

✅ To link *other* related issues (predecessors, follow-ups, umbrella
issues, etc.) in either a commit message or a PR body, use a
`References: #N` trailer. For multiple, repeat the line.
`References:` is never a closing keyword and never auto-closes
anything, regardless of where it appears.

## Commit and Push Approval

The general rule — get explicit approval before making changes or
running state-modifying commands — lives in `rules/core-principles.md`
§0 ("ALWAYS EXPLAIN BEFORE ACTING"). `git commit` and `git push` are
state-modifying commands, but (without a `-f` or `--force` flag) are
not destructive, so §0 does not govern them.

**After committing**, after tests pass, present the summary of
changes, files modified with line counts, the proposed commit message,
and the test results. The user may request code or commit
message changes, ask for more testing, or reject the changes entirely.
But all of those can be done: changes by another `git commit`, changing
the commit message by `git commit --amend`, and rejecting the changes
by `git reset --soft HEAD~1` or, if the user wants to unstage them as
well by `git reset HEAD~1`

**Before pushing**, after committing:

Unless the user prior explicitly asked to do the commit and push on the
default branch, the push should **always** be on a working branch.

If it **is** on the default branch:

1. Show the commit created and be explicit it is on the default branch.
2. Ask explicitly: "Do you want me to push this to `origin/{branch}`?"
3. Wait for explicit "yes" / "push" or similar.

Otherwise, when working on a branch, you may push without prior approval.
After all, this too is undoable. You may **never** use `--force` or `-f`
or `--mirror` flags on a push, unless you are explicit with the user you
are going to do so and explain why and get prior explicit permission.
You may use the `--force-with-lease` and `--force-if-includes` flags,
e.g. for rebasing the branch onto HEAD of the default branch.

## When Merging

Always first do a dry-run merge:
`git checkout TARGET_BRANCH && git merge --no-commit --no-ff main`.

Never squash merge.

Never merge the default branch into another branch: always rebase the
other branch.

## Fixing having committed things on the wrong branch

When you made a commit on the wrong branch:

1. **git stash** — save working changes.
2. **git reset --hard HEAD~1** — undo commit on wrong branch.
3. **git checkout CORRECT_BRANCH** — switch to correct branch.
4. **git stash pop** — re-apply the saved changes.
5. **git commit** — commit to correct branch.
