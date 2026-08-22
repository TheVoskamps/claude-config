# Claude Code Markdown Instructions Style

Read before writing or reviewing markdown whose reader is a model:
`CLAUDE.md`, rules files, `SKILL.md` bodies, agent definitions, and
any other prose a session loads as instruction.

## Preamble (not a rule source)

`rules/code-style.md` already claims prose-that-instructs-an-agent as
code, and governs whether a diff matches the file it lands in — its
naming, its structure, the linter it must pass.
`rules/comment-style.md` governs the comments inside it. This guide
governs what neither does: whether the content earns its place at
all, and how much of it there should be. A section can satisfy every
rule in those guides and still be a section that should not exist.

The reader is a capable model with a finite context window, not a new
hire who needs the procedure spelled out. Every line you add is a line
every future reader pays for — in context it cannot then spend on the
task, and in dilution of the lines that matter. Anthropic cut over 80%
of Claude Code's own system prompt for this model generation with no
measurable loss on their coding evaluations.

That cost is why the question to ask of a line is not "is this true?"
but "does a reader act differently for having read it, and is the
condition that put it here still real?" Call that the **retention
test**. It applies to what is already in the file as often as to what
is about to be added: a writer that can only append cannot maintain a
document. Deleting a section you did not write, because its condition
is gone, is the ordinary maintenance of these files.

Where a section's value is arguable, cut it rather than reword it.
Rewording preserves the length and hides the doubt; cutting resolves
it, and version control keeps the text if you were wrong.

## Rules

### Every line changes what a reader does

Every line the diff adds states something a reader would otherwise get
wrong: a constraint, a decision, a gotcha, a fact the file system does
not already show. A line whose removal leaves a reader's behavior
unchanged is a counterexample.

Counterexample shape: "This project is written in TypeScript" in a
`CLAUDE.md` sitting beside a `tsconfig.json`.

### No instruction is stated twice in one context

No instruction the diff adds repeats one already reachable in the same
context — elsewhere in the same file, in another file the session
loads, or in the tool description of the tool it governs.

Counterexample shape: a rules file restating a `CLAUDE.md` rule "for
emphasis".

A second copy is not reinforcement. It is a second thing to keep in
sync, and the two say different things the moment either is edited.

### Guidance delegates judgment rather than enumerating cases

Every behavior the diff specifies is stated as the principle behind
it, not as a list of cases, unless the cases are themselves the
content — a fixed option set, a required output shape, a literal
command.

Counterexample shape: a section listing eight named situations that
each resolve to "prefer the smaller diff".

An enumeration constrains a reader who can already derive the cases,
goes stale as new ones appear, and contradicts itself as it grows.

### Detail loads when it is needed

Every multi-step procedure the diff adds lives in a skill, and every
piece of guidance scoped to part of a tree lives in a path-scoped rule
or an on-demand file — not in always-loaded prose.

Counterexample shape: a nine-step release procedure pasted into
`CLAUDE.md`.

### Every on-demand file is reachable by a trigger and a kernel

Every file the diff adds that is not auto-loaded is announced where
its readers already look, with the condition that should make them
load it and a one-sentence statement of its hardest rule.

Counterexample shape: a new on-demand guide with no line in the
enumeration that routes readers to it.

The kernel is what keeps the file's hardest rule available to a
session that never fires the trigger.

### `CLAUDE.md` stays under 200 lines

Every `CLAUDE.md` the diff touches is under 200 lines afterwards, or
the diff does not lengthen it — a file already past target takes an
append only as part of a relocation or a displacement.

Counterexample shape: a 1158-line `CLAUDE.md` gaining a section.

What belongs there is what the repo is for, its conventions, and its
gotchas; a procedure or a subtree-scoped rule is routed away per the
rules above. Longer files consume more context and reduce adherence
(<https://code.claude.com/docs/en/memory.md>).

### No example teaches what an interface can state

No example the diff adds demonstrates a behavior that a name, a
parameter, a type, or a stated constraint could carry instead.

Counterexample shape: three worked invocations showing that a flag
takes a comma-separated list, where naming the parameter
`--issues <n,n,…>` says it once.

Examples constrain the space a reader explores: a reader that
pattern-matches yours stops at their edges.
