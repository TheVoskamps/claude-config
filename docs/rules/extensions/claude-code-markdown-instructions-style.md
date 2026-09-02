# Claude Code Markdown Instructions Style — this repo

This repo's main artifact is prose that steers a model: rules files,
`CLAUDE.md`, and the settings that decide which of them load when. It
carries no tests, and will not gain any. A function has a return value
you can assert on; a rules file has an effect on a model's behavior,
which is distributional, sensitive to the surrounding context, and
different across model versions. An assertion over that is either a
tautology (the file contains the string it contains) or a flake (the
model complied this time). Neither tells a future editor whether the
change was right. What stands in for a test suite is review against
the rules set itself, plus the linter this repo does declare — and a
diff that adds a prose-testing harness is not a fix for that, it is a
new thing to maintain that asserts nothing.

A guide here states only its own subject. Mechanics that belong to
another subject get cut rather than reworded more carefully: a code or
documentation style guide does not explain how `.gitignore` resolves,
and a reader who needs that answer runs `git check-ignore`. A
paragraph a review has corrected more than once is evidence the
material does not belong in the file at all, so treat the repeat
correction as the trigger to re-examine scope rather than as a prompt
for more precise wording.

## Every Markdown file the diff touches passes markdownlint

Every Markdown file the diff touches passes
`npx markdownlint-cli2 <file>` with zero errors, including errors that
pre-date the diff, and with the repo's `.markdownlint.jsonc` files
unmodified by the diff.

`markdownlint-cli2 --fix <file>` settles most of it mechanically.

## Every rules file the diff adds is listed in CLAUDE.md

Every file the diff adds directly in `rules/` appears in the canonical
rules list in `CLAUDE.md` as an `@`-expanded line, and every file the
diff adds directly in `docs/rules/` appears there as a plain-path line
with a trigger and a one-sentence kernel.

That list is the only enumeration of the rules set. A rules file
missing from it is a file no session ever loads.

## No section moved out of a rules file leaves a stub behind

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

## A relocated file keeps its `settings.json` allowlist coverage

For every file the diff moves between this repo's top-level
directories, `settings.json`'s `permissions.allow` carries a glob
matching the deployed `~/.claude/` path of the new location, or the
PR body flags the path left uncovered.

## No rule the diff adds argues why it is right

Every rule the diff adds to a guide in this repo states the behavior it
requires and stops, carrying no paragraph defending the rule itself.

## An instruction file with no section heading uses `##` headings

Every Markdown file the diff adds or flattens whose instructions sit
directly under the `#` title carries each of those instructions as a
`##` heading.
