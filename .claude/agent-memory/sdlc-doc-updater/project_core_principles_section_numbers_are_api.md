---
name: core-principles-section-numbers-are-api
description: In claude-config, the "## N." section numbers in rules/core-principles.md are cited downstream as "core-principles §N" — do not renumber or de-number them as a writing-style cleanup
metadata:
  type: project
---

# core-principles.md section numbers are a downstream API

`rules/core-principles.md` names its sections `## 1.` … `## 7.`. Those
numbers are quoted verbatim outside this repo — the `guardrails`
plugin cites `core-principles §1` in both
`hooks/permission-gate/classify_command.go` and that hook's
`README.md`. Grep `~/.claude/plugins/cache/thevoskamps/` for
`core-principles §` to see the current quoters.

**Why:** the doc-updater style rule "name things semantically, never
by sequence" would otherwise read as a mandate to strip these
numbers. Stripping them turns every downstream citation into a
dangling reference in a repo a worktree of this one cannot edit — the
exact hazard `.claude/rules/repo-is-claude-config-source.md` →
"Rules headings are quoted downstream" warns about.

**How to apply:** treat the numbering as fixed. When a section is
moved out and later sections shift up (PR #47 moved the old §7 into
`rules/communication-style.md`, making §8 → §7), grep the plugin cache
for citations of the shifted numbers before assuming the renumbering
is safe. Only §1 has ever been cited so far, which is why the shift
was harmless — that is a fact to re-verify, not to assume.
