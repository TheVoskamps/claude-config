---
name: feedback-sweep-the-class-on-self-referential-rules
description: When a review flags "file X violates its own stated rule Y", grep the whole PR-touched set for rule Y's pattern, not just the flagged line
metadata:
  type: feedback
---

When a review finding says a rules/style-guide file violates a rule it
itself states (e.g. `core-principles.md` §7 forbidding "count word
immediately before a self-counting list", violated by that same file's
§1), don't stop at fixing the one flagged instance. Grep every file the
PR touches for the same textual pattern before reporting the finding
fixed.

**Why:** on issue #30 / PR 34 ([[project-claude-config-repo-purpose]]),
round 4 review flagged exactly one instance, but a full-touched-file
sweep turned up two more instances of the identical pattern
(`credential-surfaces.md` "three parts", `escalation-discipline.md`
"All three of these") that had crept in during the same rewrite. Fixing
only the named line would very likely have cost a round-5 review
finding for each of the missed ones — the repo's own §8 ("sweep the
class") names this exact failure mode as something a retro previously
observed costing three review rounds on a similar defect.

**How to apply:** for issue-fixer tasks against style/rules-file repos
specifically, treat "reviewer named one instance of pattern X" as
"grep the touched-file set for pattern X" — not as "fix the one line
and move on." A plain grep with a few reasonable regex variants (count
word + noun + "are"/":") is usually enough; manually eyeball each hit
against the rule's own stated exceptions (e.g. counts that are
constraints, not tallies of a visible list) before editing, since not
every numeral is a violation.
