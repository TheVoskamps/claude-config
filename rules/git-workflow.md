# Git Workflow

## Stay within your repo

You should be run from the root of a repo. Verify with
`git rev-parse --show-toplevel` if unsure; if the starting CWD is not a
repo root, tell the user rather than guessing.

`cd` freely to any path at or below the repo root — subdirectories,
worktrees under `.claude/worktrees/`, and back again. Going outside the
repo root needs permission, per the boundary rule in
`rules/core-principles.md` §1.

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

## Commit messages

- First line: present-tense imperative verb and summary (e.g. "Add
  Lambda for account creation"); keep under 72 characters.
- Blank line.
- Detailed body: wrap at 132 characters; explain what and why.
- Use clear, descriptive commit messages.
- Focus on the "what" and "why", not the "how".
- Commit incrementally — small, focused commits rather than one large
  catch-all commit.

### Issue references

#### Closing keyword: PR body only, own issues only

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

Because auto-close-on-merge for the branch's own issues is the outcome
we want, and the PR body is the only placement that also produces the
sidebar link, the rule is:

1. **Put a closing keyword in the PR body for every issue in the
   branch's own issue set.** This is required, not forbidden — it is
   how the PR gets linked in the Development sidebar and how each
   issue auto-closes when the PR merges to the default branch.
2. **Never put a closing keyword in a commit message.** Closing
   keywords belong in the PR body only.
3. **Never aim a closing keyword at an issue outside the branch's own
   issue set** — not an umbrella/parent issue, not a predecessor, not
   a "related" issue.

**The branch's own issue set** is the set of issues the issue-developer
was tasked with when it created the branch. Most branches carry a
one-member set. A batched branch carries several: related issues
implemented together because delivering them separately would conflict
by construction — say, when each of them bumps the same version field.

The set is also encoded in the branch name, under the convention
`issue-<N1>-<N2>-…-<Nk>-<slug>`. After the `issue-` prefix, the leading
run of all-numeric hyphen-separated tokens is the set; the slug follows
and never begins with a digit. So `issue-196-201-207-pin-deps` encodes
{196, 201, 207}, and `issue-123-fix-parser` encodes {123} — the
single-issue name is the k=1 case of the same shape, unchanged.

The tasked set and the branch name normally agree, but when they don't,
**the branch name is the higher-fidelity source of truth** — the
orchestrator itself sometimes performs the final push and PR creation
(e.g. when the issue-developer dies mid-run), and in that path the
branch name is the durable record of which issues the PR closes.

The set is a **maximum, not an equality**. A PR may close a subset of
it: an issue dropped mid-flight — descoped, or deferred to a branch of
its own — simply loses its closing line, and that is not a violation.
A PR may never close a superset; an issue outside the set is off
limits however related it looks.

Every member needs **its own keyword**. GitHub's docs spell the
multi-issue form with the keyword repeated —
`Resolves #10, resolves #123` — because the parser links a reference
only when a keyword sits immediately before it. So `Closes #196, #201`
closes #196 and silently leaves #201 open. Write one line per issue,
which makes the repetition impossible to forget:

```text
Closes #196
Closes #201
Closes #207
```

For an ordinary single-issue branch that collapses to the one line it
has always been: a branch whose set is {123} carries `Closes #123` (or
`Fixes #123` / `Resolves #123`) and nothing further. Prohibited:

- A closing keyword anywhere in a commit message — including
  `Fixes #123` as a trailer, even for an issue in the branch's own set.
- A closing keyword in the PR body aimed at an issue outside the set,
  e.g. `Closes #100` in the PR body of a branch whose set is {123}.
- One keyword serving a list of references, e.g. `Closes #196, #201`,
  which closes only #196 and leaves the rest of the set open.
- `Closes Dependabot alert #88`. The parser allows nothing meaningful
  between the keyword and the `#N`: it discards the intervening
  "Dependabot alert" and reads `Closes #88`, closing issue #88. The
  trap is believing those words scope the reference — the parser has
  no concept of a Dependabot alert, it sees only
  `<keyword> ... #<N>` and closes whatever number follows.

The parser is purely syntactic, matching the keyword-then-reference
pattern, so the keywords are harmless as ordinary prose with no
adjacent issue reference ("Dependency tree after fix", "The fix lands
in PR #1070", "This closes a long-standing gap") and inside code
blocks, paths, or identifiers (`fix_bug.py`, `def resolve_path()`).
Rewriting "Dependency tree after fix" to "after patch" is
gold-plating, not compliance, and loses meaning for nothing.

To link issues *outside* the set — predecessors, follow-ups, umbrella
issues — use a `References: #N` trailer, repeated per issue, in either
a commit message or a PR body. `References:` is never a closing
keyword and never auto-closes anything, wherever it appears.

## Commit and push approval

`git commit` and `git push` without a force flag are reversible, so
they fall outside the approval carve-outs in
`rules/core-principles.md` §1 and need no advance approval on a
working branch.

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

If a commit is rejected for missing signatures, a merge is requested,
or a commit lands on the wrong branch, see
`rules/git-recovery.md` — read on demand for those rare events rather
than carried here.
