# Code Style — this repo

Extends `rules/code-style.md` for this repo. Read both: the global
guide first, this file appended as extension and override. Where the
two conflict, this file wins.

## Preamble (not a rule source)

This repo's main artifact carries no tests, and will not gain any.
That is a decision, not an omission, so the global rule "Public
behavior changes ship with a test" does not fire for it.

The reason is what the artifact is: prose that steers a model. Rules
files, `CLAUDE.md`, and the settings that decide which of them load
when. A function has a return value you can assert on; a rules file
has an effect on a model's behavior, which is distributional,
sensitive to the surrounding context, and different across model
versions. An assertion over that is either a tautology (the file
contains the string it contains) or a flake (the model complied this
time). Neither tells a future editor whether the change was right.
What stands in for a test suite is review against the rules set
itself, plus the linter this repo does declare — and a diff that adds
a prose-testing harness is not a fix for that, it is a new thing to
maintain that asserts nothing.

The exception is the executable code this repo does carry: shell
scripts, which are ordinary code with ordinary return values. Under
`.github/scripts/` the global test rule fires in full, because a
self-test already covers that surface, and the rule below says so.
`install.sh` and `plugins.sh` at the repo root carry no test suite,
so the global rule's own "in repos that already have a test suite for
that surface" clause leaves them out — a gap, not a licence to break
them.

The global guide's other rules apply unchanged. Some are easy to
misread as code-only, since this repo's source is Markdown: "Files
conform to the repo's declared formatter and linter" covers every
Markdown file here, and "Structure follows the file's existing
organization" covers a rules file's heading shape as much as a
function's.

## Rules

### Every Markdown file the diff touches passes markdownlint

Every Markdown file the diff touches passes
`npx markdownlint-cli2 <file>` with zero errors, including errors that
pre-date the diff, and with the repo's `.markdownlint.jsonc` files
unmodified by the diff.

Counterexample shape: a diff that edits one section of a rules file
and leaves an MD013 long line elsewhere in that same file.

This is the global formatter-and-linter rule instantiated with the
linter this repo declares. `markdownlint-cli2 --fix <file>` settles
most of it mechanically.

### Every script under `.github/scripts/` has a self-test

Every executable script the diff adds or changes under
`.github/scripts/` has a companion `test-<name>.sh` beside it that
exercises the changed behavior, and the companion covers the new case
the diff introduces.

Counterexample shape: a new branch condition added to
`no-back-merging-guard.sh` with no matching case in
`test-no-back-merging-guard.sh`.

This is where the global test rule bites in this repo. The existing
pair is the precedent: the guard's self-test builds throwaway git
repos and asserts the guard's exit code.

### Every rules file the diff adds is listed in CLAUDE.md

Every file the diff adds under `rules/` appears in the canonical rules
list in `CLAUDE.md`, either as an `@`-expanded line or as a plain-path
line with a trigger and a one-sentence kernel.

Counterexample shape: a new `rules/foo.md` with no `foo.md` line in
`CLAUDE.md`.

That list is the only enumeration of the rules set. A rules file
missing from it is a file no session ever loads.

### No heading title under `rules/` is rewritten in place

For every `##` or `###` heading the diff changes in an existing file
under `rules/`, the new heading contains the old heading's title —
the text after any leading ordinal — as a substring, unless the diff
removes the section outright.

Counterexample shape: renaming `core-principles.md`'s "Use shared
constants" to "Shared constant discipline" — a title
`rules/code-style.md` cites verbatim as the authority behind "No
literal is duplicated across modules".

Plugin skills and agent definitions in other repos quote these titles
verbatim as prose pointers, and a worktree of this repo cannot edit
those quoters. A leading ordinal is outside the rule because a
deletion elsewhere in the file forces the ones below it to move; a
diff that renumbers still owes the report-back a note, because a
citation of the form `core-principles.md` §N breaks silently. See
`.claude/rules/repo-is-claude-config-source.md` → "Rules headings are
quoted downstream".
