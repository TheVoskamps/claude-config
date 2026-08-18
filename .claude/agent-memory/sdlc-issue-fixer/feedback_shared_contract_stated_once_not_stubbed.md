---
name: shared-contract-stated-once-not-stubbed
description: Two sibling rules files may share one statement of a common contract, with one pointing at the other — this is allowed and is not the rejected pointer-stub shape
metadata:
  type: feedback
---

# A shared contract is stated once, and that is not a stub

When two sibling rules files carry identical text stating a contract
both obey, keep one statement and have the other point at it by
heading. This is sanctioned, even though a superficially similar
"pointer stub" shape was rejected elsewhere in the same repo.

**Why:** the owner ruled this on PR 50 for `rules/code-style.md` and
`rules/comment-style.md`, which had duplicated the structure contract
and the per-repo extension mechanics verbatim. The distinction the
owner drew: a stub is what is left behind when content moves *out* of
a file, forcing a reader to chase a pointer to learn that file's own
rule. A shared contract is different — nothing moves out, and the two
files are read together anyway (you do not write comments without the
code guide in context).

**How to apply:** deduplicate only the genuinely shared material. What
is per-subject stays in each file: its title, its trigger, its subject
clause, its preamble, its rules, and its own filenames. Give the
canonical statement its own `##` heading so the sibling can cite it as
`file.md` → "Heading" rather than gesturing at a region. Contrast with
[[no-stub-after-moving-a-rule]]; see also
[[guide-states-only-its-own-subject]].
