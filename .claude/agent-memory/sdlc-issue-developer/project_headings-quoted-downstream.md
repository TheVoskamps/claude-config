---
name: headings-quoted-downstream
description: Heading text in this repo's rules/*.md is quoted verbatim by @thevoskamps plugin skills and agents, so renaming a heading strands references in repos you cannot edit from here.
metadata:
  type: project
---

# Rules headings are quoted downstream

Section headings in `rules/*.md` are load-bearing outside this repo:
`@thevoskamps` plugin skills and agent definitions cite them as prose
pointers. As of 2026-08-02, "PR body only, own issue only" from
`git-workflow.md` appears verbatim in the `sdlc` `issue-developer`
agent and in `github-prs`' `pr-create` skill and README. Treat a
heading rename as an API change, not a wording tweak.

**Why:** those plugins live in separate repos, delivered through the
marketplace declared in `settings.json`. A worktree of *this* repo
cannot edit them, so a rename you make here lands as a dangling
reference over there, and nobody notices until a reader greps for a
string that no longer exists.

**How to apply:** when a task's substance is in the body of a rules
section, prefer leaving the heading alone. If the heading is genuinely
wrong after the change, make the smallest edit that keeps the old text
a substring of the new one — a rename to "own issues only" still
matches a grep for "PR body only, own issue" — and say in the
report-back that downstream quoters may need a follow-up. To check who
quotes what, grep the plugin cache under
`~/.claude/plugins/cache/thevoskamps/`; reading outside the repo is
allowed, writing there is not.
