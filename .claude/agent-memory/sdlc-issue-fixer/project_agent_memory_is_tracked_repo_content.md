---
name: agent-memory-is-tracked-repo-content
description: In claude-config, .claude/agent-memory/ is git-tracked, so it counts as "the repo" for any repo-wide absence claim in a PR body — grep it before asserting nothing references a renamed heading or section number
metadata:
  type: project
---

# Agent memory counts as repo content for absence claims

`.claude/agent-memory/**` is tracked by git in this repo (`git ls-files
.claude/agent-memory/` lists it). Any PR-body claim of the form
"nothing in the repo references X" must be grepped over it too, not
just over `rules/`, `CLAUDE.md`, and `.claude/rules/`.

**Why:** memory entries cite rules headings and section numbers
verbatim, so a renumbering that looks unreferenced from `rules/` alone
is routinely referenced from `.claude/agent-memory/`. An absence claim
that skips it is cheap to check and expensive to get wrong.

**How to apply:** when a change renames a rules heading or renumbers a
section, grep the whole worktree (excluding only `.git` and
`.claude/worktrees`), and state in the PR body how the agent-memory
hits are handled rather than omitting them. Do **not** edit those
entries yourself — the `agent-memory-scrubber` pass before
`/pr-ready` owns curation, and an issue-fixer rewriting them collides
with it.
