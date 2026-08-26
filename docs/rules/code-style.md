# Code Style

Read before writing or reviewing code — and before writing or
reviewing any file a repo declares a formatter or linter for, whatever
that file's language.

"Code" here includes prose written to instruct an agent: rules files,
skills, agent definitions, and the like are source a model executes,
so this guide governs them. Prose written for a human reader is not
governed here: keep it terse and self-contained, and state no count
the reader can derive from what is already shown.

This guide asks whether such prose matches the file it lands in.
Whether it earns its place at all, and how much of it there should be,
is `docs/rules/claude-code-markdown-instructions-style.md`.

## Structure contract

This contract governs this guide, its sibling comment guide, and any
per-repo extension file of either. It is stated here once; the comment
guide points at it rather than restating it.

Each `###` heading in a guide is exactly one rule, phrased as a
falsifiable claim.

The evidence a rule quantifies over is anything a second reader can
independently go and re-check: the diff, the repository at head, and
stable external documentation such as a language's standard-library
reference. The test is reproducibility, not location.

A rule about matching what a file already does cannot be settled from
the diff alone — the convention it names lives in the lines the diff
did not touch — so it is checked against a pair: the added lines, and
the lines they fail to match. A rule about every call site quantifies
over the whole repository. A rule about a helper that already exists
quantifies over wherever that helper is documented. Each stays
disprovable, because a disagreeing reader can go and look at the same
evidence and get the same answer.

What is excluded is a rule resting on the reviewer's taste with
nothing a disagreeing reader could go and look at.

A tool enumerating rules from a guide reads its `###` headings and
nothing else.

## Preamble (not a rule source)

The governing instinct is that your diff should be indistinguishable
from the file it lands in. A reader running `git blame` should learn
who wrote a line, not be able to guess it from the style.

That instinct is not itself checkable, which is why it lives here
rather than below. It resolves the cases the rules do not reach: an
unfamiliar language, a file with two competing idioms in it, a
convention that is clearly a mistake but is nevertheless the
convention. When the rules below are silent, copy what is already
there; when what is already there is genuinely wrong, fix it as its
own change rather than as a silent rider on an unrelated one.

Style is downstream of correctness, never a substitute for it. A
change that satisfies every rule below and is wrong is still wrong.
Root-cause discipline is `rules/core-principles.md` → "Fix root
causes, not symptoms", which is loaded in every session. The rules
below that cite it are the forms it takes that a diff can be checked
against.

Suppression is not a fix. `eslint-disable-next-line`, a blanket
`# type: ignore`, a loosened linter config: each hides the problem and
leaves it for the next reader. When a lint or type error resists a
quick fix, find the correct annotation or type definition, or check
whether the real problem is configuration (parser settings,
`tsconfig`, plugin resolution). Web search is fair game for
understanding the rule you are hitting. The rules below that this
paragraph governs — "No suppression directive is added" and "Files
conform to the repo's declared formatter and linter" — are its
diff-checkable cases, not its whole content.

## Rules

### Naming follows the file's dominant convention

No identifier the diff introduces uses a naming convention — case
style, prefix/suffix habit, abbreviation habit — that differs from the
convention already dominant in the file it lands in.

Counterexample shape: a `snake_case` local added to a file whose every
other local is `camelCase`.

### Structure follows the file's existing organization

No unit the diff adds — function, method, class, module-level block —
departs from the organizing convention the file it lands in already
follows: where declarations sit relative to their use, how a unit is
split into helpers rather than nested further, where errors are
handled relative to where they arise, and the order the file groups
its members in.

Counterexample shape: a 200-line function with four levels of nesting
added to a file whose other functions each stay under 30 lines and
delegate to named helpers.

### No suppression directive is added

No line the diff adds is a linter, type-checker, or compiler
suppression: `eslint-disable`, `@ts-ignore`, `@ts-expect-error`,
`# type: ignore`, `# noqa`, `@SuppressWarnings`, `#pragma warning
disable`, or any equivalent.

The authority is `rules/core-principles.md` → "Fix root causes, not
symptoms", and the preamble's suppression-is-not-a-fix paragraph
narrows it to suppression. This rule is the compile-time diff-checkable
case of both, and no more: a diff can add no suppression and still
paper over a root cause. Removing an existing suppression is not a
violation — only adding one is.

### Every symbol the diff introduces is referenced

Every function, class, constant, type, variable, parameter, and import
the diff adds has at least one reference: a call site, a re-export, a
test, or a documented public entry point.

Counterexample shape: a helper added in the same commit as its only
would-be caller, where the caller does not in fact call it.

### No literal is duplicated across modules

No string or numeric literal that names a shared resource — a table
name, a queue name, an env var key, a route path, a feature flag — is
written literally in more than one module in the diff. It is defined
once and imported.

The authority is "Use shared constants" below. Literals confined to a
single module, and literals with no cross-module meaning, are outside
this rule.

### No caught error is discarded

No `catch`, `except`, `rescue`, or equivalent block the diff adds ends
without doing one of: handling the error, re-raising it, wrapping it
in a raised error, or returning it as a value the caller must handle.

Counterexample shape: an empty catch block, or one whose entire body
is a log call followed by falling through to the success path.

The authority is `rules/core-principles.md` → "Fix root causes, not
symptoms". A swallowed error is the runtime form of the suppression
the preamble forbids at compile time: both make the symptom disappear
and leave the cause in place.

### Existing helpers are reused rather than reimplemented

No function the diff adds duplicates the behavior of a function
already reachable from the same module — already imported, already
exported by a sibling, or already in the language's standard library.

Counterexample shape: a hand-rolled deep-merge added to a file that
already imports the project's own merge utility.

### Signature changes update every call site

For every function, method, or exported constant whose signature or
type the diff changes, the diff also updates every call site in the
repository, or the change is proven backward-compatible by a default
value or overload the diff adds.

Counterexample shape: a required parameter added to a function the
diff leaves called with the old arity elsewhere in the repo.

### Files conform to the repo's declared formatter and linter

Every file the diff touches passes, in whole, the formatter and linter
the repo already declares in its own configuration — including the
lines the diff did not change, and including files the repo lints as
prose rather than as code, such as Markdown.

A diff that loosens the config to make itself pass violates this rule
rather than satisfying it, and so does an inline disable comment
(see "No suppression directive is added"). A config carve-out is
legitimate only where a rule is genuinely undefined for the content —
a line-length rule has no meaning inside a code fence or a table cell,
because neither can be rewrapped — and the diff states that reasoning
in a comment next to the setting.

Counterexample shape: a diff that touches a file carrying pre-existing
lint errors and leaves them there.

### Public behavior changes ship with a test

Every change in behavior the diff makes to a public entry point —
exported function, HTTP route, CLI flag, event handler — is covered by
a test the diff adds or updates, in repos that already have a test
suite for that surface.

Counterexample shape: a new CLI flag with no test exercising it, in a
repo whose other flags are each tested.

### Use shared constants

Every resource name and other cross-module string literal the diff
introduces is defined once in the project's central constants module
(e.g. `shared-constants.ts`) and referenced from every use site, under
the naming convention that module's existing entries already follow.

Counterexample shape: a new queue name declared inline in the stack
that creates it, with the consuming module repeating the string.

### Sweep the class

For every defect the diff fixes, the diff also fixes every other
instance of that same class of defect within the files the diff
touches or the unit under review.

Counterexample shape: a diff that repairs one dangling cross-reference
to a renamed file and leaves a second one in another file it edits.

## Per-repo extension

Before applying the rules above, look for
`<repo>/docs/rules/extensions/code-style.md` in the repo you are
working in, and read it if it is there. Its sibling guide's extension
carries the fixed name
`<repo>/docs/rules/extensions/comment-style.md`. The two files are
independent, and a repo may carry either, both, or neither.

Nothing about a repo's extension file announces itself. Repo authors
write those files, and nothing obliges them to point back here, so the
fixed name is the whole discovery mechanism: look for it, and treat a
missing file as "this repo adds nothing", not as "there is nothing to
look for".

Resolution is global-then-repo: this guide first, the repo file
appended as extension and override. Where the two conflict, the repo
file wins — it is the more specific statement about the code actually
in front of you. That order is structural rather than conventional,
because this guide is already loaded at the moment the instruction to
fetch the repo file fires.

The repo file follows the structure contract above: one rule per
heading, each rule a falsifiable claim, and evidence a second reader
can independently re-check. A tool reads the concatenation, so a repo
file that drops the structure makes its own rules unreadable to that
tool.

A repo file may carry no rules at all. A preamble stating why a rule
above does not fire in this repo is a legitimate whole file: it tells
a reader that the silence is a decision rather than an omission.
