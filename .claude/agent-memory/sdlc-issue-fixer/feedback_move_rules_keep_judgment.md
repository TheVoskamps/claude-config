---
name: move-rules-keep-judgment
description: When consolidating content out of an @-expanded rules file, move only the diff-checkable rules; judgment that applies with no diff in play stays in the always-on set
metadata:
  type: feedback
---

# Move rules, keep judgment

When a task says a class of content consolidates out of an
`@`-expanded rules file, split the section rather than moving it
whole. The parts phrased as claims a diff can be checked against move
to the on-demand guide. The judgment underneath them stays where it
was, and the moved rules cite it as their authority.

**Why:** the owner's ruling on #43 was that *coding standards* leave
`core-principles.md`. Root-cause discipline went with them, and that
was wrong: it governs a failed deploy, an expired credential, a
misread log — situations with no diff at all. `CLAUDE.md` states the
test for the always-on set: a file earns `@`-expansion only when its
applicability cannot be recognized without the rule already in
context. You cannot notice you are papering over a symptom unless the
rule is already loaded, so it qualifies.

**How to apply:** before moving a section out of an `@`-expanded
file, ask whether each paragraph is checkable against a diff. If a
paragraph fires in situations where no diff exists, it stays. This
does not conflict with [[no-stub-after-moving-a-rule]] — nothing is
stubbed, because the judgment is not moved in the first place, and the
moved rules point *back* at it the way "No literal is duplicated
across modules" points at "Use shared constants".
