---
name: feedback-adjudicate-count-words-before-flagging
description: When reviewing this repo's rules files against rules/communication-style.md "No derivable numbers", classify each numeral as tally / constraint / anaphor / quotation before flagging — most numerals are not violations
metadata:
  type: feedback
---

# Adjudicate count words before flagging

Reviewing `claude-config`'s rules set against the no-derivable-numbers
ban (`rules/communication-style.md` → "No derivable numbers") means
grepping for number words and then **adjudicating each hit**, not
flagging them. A raw grep over `CLAUDE.md` + `rules/` returns roughly a
dozen hits, of which typically zero to one are actual violations,
because the ban exempts several numeral shapes that a plain grep can't
distinguish from a real tally. Classify each hit:

- **Tally** (the violation): count word immediately before an adjacent
  enumerated list — bullets, numbered items, *or a table* — that the
  reader can count. Only this shape is forbidden.
- **Constraint** (exempt, and the rule says so explicitly): the number
  is a bound, not a count of a visible list — "retry up to 3 times",
  "two to four options, no more".
- **Anaphor** (exempt): a back-reference to an already-introduced set —
  "The two axes are independent" after both axes were named.
- **Quotation** (exempt): the rule quotes the forbidden pattern to
  define it, so `communication-style.md` legitimately contains "The
  four kinds are…" as an example of what not to write.
- **Prose continuation** (exempt): "Two habits, one subject" followed
  by "The first is… The second is…" and `##` headings — the ban scopes
  itself to a number the reader can derive from an *adjacent* list or
  table, and running prose is not one.

**Why:** flagging an exempt numeral is a fabricated finding in the file
that *defines* the rule — maximally embarrassing, and costly at a
review cap. Equally, missing a real one costs a round. The §7 text
carries its own carve-out ("a count that carries independent
meaning… rather than a tally of something already in view"), so the
adjudication criteria are in the file itself; read them before
judging.

**How to apply:** when a review round flags a derivable-number
instance, expect the fixer to sweep per `core-principles.md` §7 ("Sweep
the class") and expect the sweep to touch files beyond the flagged
one. Verify the sweep by grepping the *touched-file set* and
classifying each hit as above, and separately confirm each sweep edit
preserved meaning — the count word is often adjacent to load-bearing
text ("the report has the following parts **and nothing else**"), where
deleting the numeral is safe but deleting the surrounding qualifier
would silently loosen a constraint. Check the qualifier survived, not
just that the numeral left. Also check whether a flagged line is even
in the diff: pre-existing lines outside the PR's changes are not this
PR's findings.
