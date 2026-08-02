---
name: feedback-adjudicate-count-words-before-flagging
description: When reviewing this repo's rules files for core-principles.md §7 (no count before a self-counting list), classify each numeral as tally / constraint / anaphor / quotation before flagging — most numerals are not violations
metadata:
  type: feedback
---

# Adjudicate count words before flagging

Reviewing `claude-config`'s rules set for §7 violations ("no 'number
of' before a self-counting list") means grepping for number words and
then **adjudicating each hit**, not flagging them. A raw grep over
`CLAUDE.md` + `rules/` returns roughly a dozen hits, of which typically
zero to one are actual violations, because §7 exempts several numeral
shapes that a plain grep can't distinguish from a real tally. Classify
each hit:

- **Tally** (the violation): count word immediately before an adjacent
  enumerated list — bullets, numbered items, *or a table* — that the
  reader can count. Only this shape is forbidden.
- **Constraint** (exempt, and §7 says so explicitly): the number is a
  bound, not a count of a visible list — "retry up to 3 times", "two
  to four options, no more".
- **Anaphor** (exempt): a back-reference to an already-introduced set —
  "The two axes are independent" after both axes were named.
- **Quotation** (exempt): §7 quotes the forbidden pattern to define it,
  so `core-principles.md` legitimately contains "The four kinds are…"
  as an example of what not to write.
- **Prose continuation** (exempt): "Two habits, one subject" followed
  by "The first is… The second is…" and `##` headings — §7 scopes
  itself to prose introducing an *adjacent enumerated list*, and
  running prose is not one.

**Why:** flagging an exempt numeral is a fabricated finding in the file
that *defines* the rule — maximally embarrassing, and costly at a
review cap. Equally, missing a real one costs a round. The §7 text
carries its own carve-out ("a count that carries independent
meaning… rather than a tally of a list already in view"), so the
adjudication criteria are in the file itself; read them before
judging.

**How to apply:** when a review round flags a §7 instance, expect the
fixer to sweep per §8 and expect the sweep to touch files beyond the
flagged one. Verify the sweep by grepping the *touched-file set* and
classifying each hit as above, and separately confirm each sweep edit
preserved meaning — the count word is often adjacent to load-bearing
text ("the report has the following parts **and nothing else**"), where
deleting the numeral is safe but deleting the surrounding qualifier
would silently loosen a constraint. Check the qualifier survived, not
just that the numeral left. Also check whether a flagged line is even
in the diff: pre-existing lines outside the PR's changes are not this
PR's findings.
