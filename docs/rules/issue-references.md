# Issue References

Read this file before writing a PR body or a commit message that
references an issue.

## Closing keyword: PR body only, own issues only

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

For an ordinary single-issue branch, that collapses to the one line it
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
