---
name: no-stub-after-moving-a-rule
description: When rules content moves between files in claude-config, delete the old section outright — no stub, no kernel line pointing at the new home
metadata:
  type: feedback
---

# No stub after moving a rule

When a section of a rules file moves to another rules file, remove the
old section completely. Do not leave a stub heading, a one-line kernel,
or a "moved to X" pointer behind.

**Why:** the owner ruled this explicitly while relocating
core-principles' "Fix root causes, not symptoms" and "Leave Markdown
clean" into the style guides on PR 50 — the pointer-stub shape was
named and rejected. A rules set with stubs makes every reader load two
files to learn one rule, and the stub drifts from the real rule.

**How to apply:** when a fix relocates rules content, delete the source
section, renumber what is left if the file numbers its sections, and
sweep for rules that cited the deleted section as authority — they must
stop citing a heading that no longer exists. Say in the report-back
that `§N` citations outside the repo break, since a worktree cannot
edit the plugin repos that quote them.
