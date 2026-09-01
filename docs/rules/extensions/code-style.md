# Code Style — this repo

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

A guide here states only its own subject. Mechanics that belong to
another subject get cut rather than reworded more carefully: a code or
documentation style guide does not explain how `.gitignore` resolves,
and a reader who needs that answer runs `git check-ignore`. A
paragraph a review has corrected more than once is evidence the
material does not belong in the file at all, so treat the repeat
correction as the trigger to re-examine scope rather than as a prompt
for more precise wording.

The global guide's other rules apply unchanged. Some are easy to
misread as code-only, since this repo's source is Markdown: "Files
conform to the repo's declared formatter and linter" covers every
Markdown file here, and the global guide's preamble covers a rules
file's heading shape as much as a function's.

## Rules

### Every Markdown file the diff touches passes markdownlint

Every Markdown file the diff touches passes
`npx markdownlint-cli2 <file>` with zero errors, including errors that
pre-date the diff, and with the repo's `.markdownlint.jsonc` files
unmodified by the diff.

This is the global formatter-and-linter rule instantiated with the
linter this repo declares. `markdownlint-cli2 --fix <file>` settles
most of it mechanically.

### Every script under `.github/scripts/` has a self-test

Every executable script the diff adds or changes under
`.github/scripts/` has a companion `test-<name>.sh` beside it that
exercises the changed behavior, and the companion covers the new case
the diff introduces.

This is where the global test rule bites in this repo. The existing
pair is the precedent: the guard's self-test builds throwaway git
repos and asserts the guard's exit code.

### Every rules file the diff adds is listed in CLAUDE.md

Every file the diff adds directly in `rules/` appears in the canonical
rules list in `CLAUDE.md` as an `@`-expanded line, and every file the
diff adds directly in `docs/rules/` appears there as a plain-path line
with a trigger and a one-sentence kernel.

That list is the only enumeration of the rules set. A rules file
missing from it is a file no session ever loads.

### No section moved out of a rules file leaves a stub behind

For every section the diff removes from one file under `rules/` or
`docs/rules/` and adds to another, the source file retains nothing of
it: no stub heading, no one-line kernel, no "moved to X" pointer.

A stub makes every reader load two files to learn one rule, and it
drifts from the rule it points at. Two sibling guides sharing a single
statement of a contract they both obey is a different shape and is
allowed: nothing moved out, so neither file sends a reader chasing a
pointer to reach its own rule. The code guide's "Structure contract",
which the documentation guide cites instead of restating, is that
sanctioned shape.

### A relocated file keeps its `settings.json` allowlist coverage

For every file the diff moves between this repo's top-level
directories, `settings.json`'s `permissions.allow` carries a glob
matching the deployed `~/.claude/` path of the new location, or the
PR body flags the path left uncovered.

### No rule the diff adds argues why it is right

Every rule the diff adds to a guide in this repo states the behavior it
requires and stops, carrying no paragraph defending the rule itself.

### An instruction file with no section heading uses `##` headings

Every Markdown file the diff adds or flattens whose instructions sit
directly under the `#` title carries each of those instructions as a
`##` heading.
