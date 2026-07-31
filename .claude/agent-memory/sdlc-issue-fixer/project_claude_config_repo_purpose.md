---
name: project-claude-config-repo-purpose
description: TheVoskamps/claude-config repo is the source of ~/.claude global config; PR 34/issue #30 was a full rewrite of CLAUDE.md + rules/ for a frontier-model fleet
metadata:
  type: project
---

`TheVoskamps/claude-config` is the source repo for `~/.claude/` (see
its checked-in `.claude/rules/repo-is-claude-config-source.md`).
Editing `CLAUDE.md` and `rules/*.md` in this repo is ordinary in-repo
work, not the "propose before editing global ~/.claude" case — that
carve-out only applies to editing the deployed copy directly from some
other repo.

Issue #30 / PR 34 rewrote the entire `@`-expanded rules set (CLAUDE.md
plus eight files under `rules/`) for a fleet whose default-spawned
agents are Opus 5 / Fable 5 — condensing register (dropped
CRITICAL/NEVER/ALWAYS shouting), deduplicating overlapping rules
(label-uncertainty.md absorbed the old §9 "verify the territory"
content), and splitting always-loaded (`@`-expanded) files from
on-demand (plain-path, trigger-loaded) files based on whether a rule
"shapes judgment continuously" vs. "announces itself at a crisp
moment."

**Why:** the PR went through at least 4 rounds of review. Round 4
caught a self-referential bug: `core-principles.md` §7 ("no 'number
of' before a self-counting list") was itself violated by §1's "Four
categories are the exception." line, plus two more instances of the
same pattern that crept into other rules files during the rewrite
(`credential-surfaces.md`, `escalation-discipline.md`) — sweeping for
the *class* of defect across all PR-touched files (not just the
originally-flagged line) caught them in one pass instead of costing
another review round. See [[feedback-sweep-the-class-on-self-referential-rules]].

**How to apply:** when fixing a review finding that names a specific
rule violation *of a rule the repo itself states*, always grep the
full touched-file set for the same pattern before considering the
finding closed — this repo's rules files are exactly the kind of
content where the rule and a violation of it can coexist in the same
diff.
