# Code Style

Read before writing or reviewing code.

The **preamble** below is judgment guidance for a human or an agent
holding the whole change in its head. The **rules** under it are the
machine-consumable part: each `###` heading under
"Rules" is exactly one rule, phrased as a claim about a diff that a
single quoted counterexample refutes. A tool enumerating rules from
this file reads the `###` headings under "Rules" and nothing else.

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

## Rules

### Naming follows the file's dominant convention

No identifier the diff introduces uses a naming convention — case
style, prefix/suffix habit, abbreviation habit — that differs from the
convention already dominant in the file it lands in.

Counterexample shape: a `snake_case` local added to a file whose every
other local is `camelCase`.

### No suppression directive is added

No line the diff adds is a linter, type-checker, or compiler
suppression: `eslint-disable`, `@ts-ignore`, `@ts-expect-error`,
`# type: ignore`, `# noqa`, `@SuppressWarnings`, `#pragma warning
disable`, or any equivalent.

The authority is `rules/core-principles.md` → "Fix root causes, not
symptoms"; this rule is the diff-checkable form of that section's
suppression-directive case only. Passing it says nothing about the
rest of that section — a diff can add no suppression and still paper
over a root cause. Removing an existing suppression is not a violation
— only adding one is.

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

The authority is `rules/core-principles.md` → "Use shared constants".
Literals confined to a single module, and literals with no
cross-module meaning, are outside this rule.

### No caught error is discarded

No `catch`, `except`, `rescue`, or equivalent block the diff adds ends
without doing one of: handling the error, re-raising it, wrapping it
in a raised error, or returning it as a value the caller must handle.

Counterexample shape: an empty catch block, or one whose entire body
is a log call followed by falling through to the success path.

### Existing helpers are reused rather than reimplemented

No function the diff adds duplicates the behaviour of a function
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

Every file the diff touches passes the formatter and linter the repo
already declares in its own configuration, with that configuration
unmodified by the diff.

The authority is `rules/core-principles.md` → "Leave Markdown clean",
generalized from Markdown to every language the repo lints: a diff
that loosens the config to make itself pass is a counterexample, not a
compliance.

### Public behaviour changes ship with a test

Every change in behaviour the diff makes to a public entry point —
exported function, HTTP route, CLI flag, event handler — is covered by
a test the diff adds or updates, in repos that already have a test
suite for that surface.

Counterexample shape: a new CLI flag with no test exercising it, in a
repo whose other flags are each tested.

## Per-repo extension

A repo extends or overrides this guide with
`<repo>/.claude/rules/code-style.md`, tracked the same way that repo
already tracks `<repo>/.claude/rules/repo-config.md`. Git reaches a
file only when every parent directory is un-ignored, so a `.gitignore`
that un-ignores the `.claude/rules/` directory and matches nothing
inside it picks the new file up with no further change — that one
directory negation already covers every sibling. A by-name negation
line is needed only where some pattern still matches the file itself,
such as a recursive `*` or `.claude/**` ignore that re-catches the
directory's contents. Its sibling guide has its own extension file at
the fixed name `<repo>/.claude/rules/comment-style.md`; the two files
are independent, and a repo may carry either, both, or neither.

Resolution is global-then-repo: this file first, the repo file
appended as extension and override. Where the two conflict, the repo
file wins — it is the more specific statement about the code actually
in front of you.

The repo file follows the same structure as this one: one rule per
heading, each rule a claim about a diff that a quoted counterexample
refutes, judgment-only guidance confined to a marked preamble. A tool
reads the concatenation, so a repo file that drops the structure makes
its own rules unreadable to that tool.
