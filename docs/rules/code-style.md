# Code Style

Read before writing or reviewing a file a computer interprets or
compiles — source in any language, a shell script, a build file, a
config a tool parses — and the inline comments inside such a file.
That is this guide's whole remit.

## Structure contract

This contract governs this guide, the documentation guide, and any
per-repo extension file of either.

Each `###` heading in a guide is exactly one rule, phrased as a
falsifiable claim.

The evidence a rule quantifies over is anything a second reader can
independently go and re-check: the diff, the repository at head, and
stable external documentation such as a language's standard-library
reference. The test is reproducibility, not location.

What is excluded is a rule resting on the reviewer's taste with
nothing a disagreeing reader could go and look at.

A tool enumerating rules from a guide reads its `###` headings and
nothing else.

## Preamble (not a rule source)

A diff matches the comment density, style, naming, idiom, and
structure of the surrounding codebase. A reader running `git blame`
should learn who wrote a line, not be able to guess it from the style.
A file the diff creates has no surrounding lines of its own, so the
codebase around it is what it matches.

That expectation is not itself checkable, which is why it lives here
rather than below. It resolves the cases the rules do not reach: an
unfamiliar language, a file with two competing idioms in it, a
convention that is clearly a mistake but is nevertheless the
convention. When the rules below are silent, copy what is already
there; when what is already there is genuinely wrong, fix it as its
own change rather than as a silent rider on an unrelated one.

Style is downstream of correctness, never a substitute for it. A
change that satisfies every rule below and is wrong is still wrong.
Fix the root cause of an error rather than its symptom.

Suppression is not a fix. `eslint-disable-next-line`, a blanket
`# type: ignore`, a loosened linter config: each hides the problem and
leaves it for the next reader. When a lint or type error resists a
quick fix, find the correct annotation or type definition, or check
whether the real problem is configuration (parser settings,
`tsconfig`, plugin resolution). Web search is fair game for
understanding the rule you are hitting.

The rules below that the correctness and suppression paragraphs above
govern — "No suppression directive is added", "No caught error is
discarded", and "Files conform to the repo's declared formatter and
linter" — are their diff-checkable cases, not their whole content.

## Comments (not a rule source)

A comment states a constraint the code cannot show. The code already
shows what it does, in a notation more precise than English and one
that cannot drift out of date. What the code cannot show is the world
outside it: the upstream API that returns `null` for a 404 instead of
raising, the ordering two functions must keep because a third depends
on it, the constant that must match a value in a config file the
compiler never sees, the obvious-looking simpler approach that was
tried and does not work.

The audience is a maintainer arriving in two years with no memory of
this change, not the reviewer reading it this week. That single
substitution settles most cases: the reviewer wants to know why you
made the change, and the maintainer wants to know what will break if
they undo it.

A comment's text is prose: one idea per sentence, active voice,
concrete verbs. The rules below govern whether the comment belongs at
all.

## Rules

### No suppression directive is added

No line the diff adds is a linter, type-checker, or compiler
suppression: `eslint-disable`, `@ts-ignore`, `@ts-expect-error`,
`# type: ignore`, `# noqa`, `@SuppressWarnings`, `#pragma warning
disable`, or any equivalent. Removing an existing suppression is not a
violation — only adding one is.

### Every symbol the diff introduces is referenced

Every function, class, constant, type, variable, parameter, and import
the diff adds has at least one reference: a call site, a re-export, a
test, or a documented public entry point.

### No caught error is discarded

No `catch`, `except`, `rescue`, or equivalent block the diff adds ends
without doing one of: handling the error, re-raising it, wrapping it
in a raised error, or returning it as a value the caller must handle.

### Existing helpers are reused rather than reimplemented

No function the diff adds duplicates the behavior of a function
already reachable from the same module — already imported, already
exported by a sibling, or already in the language's standard library.

### Signature changes update every call site

For every function, method, or exported constant whose signature or
type the diff changes, the diff also updates every call site in the
repository, or the change is proven backward-compatible by a default
value or overload the diff adds.

### Files conform to the repo's declared formatter and linter

Every file the diff touches passes, in whole, the formatter and linter
the repo already declares in its own configuration, including the
lines the diff did not change.

A diff that loosens the config to make itself pass violates this rule
rather than satisfying it, and so does an inline disable comment
(see "No suppression directive is added"). A config carve-out is
legitimate only where a rule is genuinely undefined for the content —
a line-length rule has no meaning inside a code fence or a table cell,
because neither can be rewrapped — and the diff states that reasoning
in a comment next to the setting.

### Public behavior changes ship with a test

Every change in behavior the diff makes to a public entry point —
exported function, HTTP route, CLI flag, event handler — is covered by
a test the diff adds or updates, in repos that already have a test
suite for that surface.

### Shared resource names live in the constants module

Every resource name and other cross-module string literal the diff
introduces — a table name, a queue name, an env var key, a route path,
a feature flag — is defined once in the project's central constants
module (e.g. `shared-constants.ts`) and referenced from every use site,
under the naming convention that module's existing entries already
follow. No module in the diff writes such a literal a second time in
place of the reference.

### A defect fix covers every in-scope instance of its class

For every defect the diff fixes, the diff also fixes every other
instance of that same class of defect within the files the diff
touches or the unit under review.

### No comment narrates provenance

No comment the diff adds records the history of the code rather than a
property of it: which issue or PR produced it, what it used to be, who
asked for it, when it changed, or that it was a review fix. A tracker
reference is allowed only where a rule below explicitly requires one.

### No comment argues correctness to the reviewer

No comment the diff adds defends the change to whoever is reviewing
it: assertions that the code is safe, correct, tested, or equivalent
to what it replaced, addressed at the reader of the diff rather than
the reader of the file.

A comment naming a constraint a future maintainer must not violate is
not this, even when it explains why. The distinguishing question: does
the comment still make sense to someone who never saw this diff? If it
does, it is a constraint. If it only makes sense next to the change,
it belongs in the PR body.

### No comment contradicts the code it sits on

No comment the diff leaves in place — added or pre-existing on a line
the diff changes — makes a claim the code around it no longer
satisfies: a stale parameter name, a stale return description, a
stale invariant, a stale count of the things below it.

### Every TODO carries a tracker reference

Every `TODO`, `FIXME`, `HACK`, or `XXX` marker the diff adds names the
tracker issue that will resolve it.

## Per-repo extension

Before applying the rules above, look for
`<repo>/docs/rules/extensions/code-style.md` in the repo you are
working in, and read it if it is there. The documentation guide's
extension carries the fixed name
`<repo>/docs/rules/extensions/documentation-style.md`. The two files
are independent, and a repo may carry either, both, or neither.

Nothing about a repo's extension file announces itself, so the fixed
name is the whole discovery mechanism: look for it, and treat a
missing file as "this repo adds nothing", not as "there is nothing to
look for".

Resolution is global-then-repo: this guide first, the repo file
appended as extension and override. Where the two conflict, the repo
file wins.

The repo file follows the structure contract above. It may carry no
rules at all: a preamble stating why a rule above does not fire in
this repo is a legitimate whole file.
