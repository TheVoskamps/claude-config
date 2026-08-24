# Claude Code Markdown Instructions Style

Read before writing or reviewing markdown whose reader is a model:
`CLAUDE.md`, rules files, `SKILL.md` bodies, agent definitions, and
any other prose a session loads as instruction.

## Questions of fit and of comments go to the sibling guides

Take whether a diff matches the file it lands in — its naming, its
structure, the linter it must pass — to `rules/code-style.md`, which
already claims prose-that-instructs-an-agent as code. Take the
comments inside it to `rules/comment-style.md`. This guide governs
what neither does: whether the content earns its place at all, and how
much of it there should be.

## A line earns its place by the retention test

Ask of a line not "is this true?" but "does a reader act differently
for having read it, and is the condition that put it here still
real?" Call that the **retention test**. Apply it to what is already
in the file as often as to what is about to be added: a writer that
can only append cannot maintain a document. Delete a section you did
not write when its condition is gone.

## The retention test defaults to deletion

When you cannot tell whether a line earns its place, it does not, and
judgment is needed only to keep it. Adding a line to an instruction
file is what fires the test — state what a reader does differently for
that line, and if you cannot state it, the line does not go in. Where
a section's value is arguable, cut it rather than reword it.

## Every line changes what a reader does

Every line the diff adds states something a reader would otherwise get
wrong: a constraint, a decision, a gotcha, a fact the file system does
not already show.

## No instruction is stated twice in one context

No instruction the diff adds repeats one already reachable in the same
context — elsewhere in the same file, in another file the session
loads, or in the tool description of the tool it governs.

## Guidance delegates judgment rather than enumerating cases

Every behavior the diff specifies is stated as the principle behind
it, not as a list of cases, unless the cases are themselves the
content — a fixed option set, a required output shape, a literal
command.

## Detail loads when it is needed

Every multi-step procedure the diff adds lives in a skill, and every
piece of guidance scoped to part of a tree lives in a path-scoped rule
or an on-demand file — not in always-loaded prose.

## Every on-demand file is reachable by a trigger and a kernel

Every file the diff adds that is not auto-loaded is announced where
its readers already look, with the condition that should make them
load it and a one-sentence statement of its hardest rule.

## `CLAUDE.md` stays under 200 lines

Every `CLAUDE.md` the diff touches is under 200 lines afterwards, or
the diff does not lengthen it — a file already past target takes an
append only as part of a relocation or a displacement.

## `CLAUDE.md` holds purpose, gotchas, and a routing table

Every line the diff adds to a `CLAUDE.md` states what the repo is for,
states a gotcha it carries, or routes a reader to the file holding the
rest. A convention goes in a rules file the routing table reaches.

## No example teaches what an interface can state

No example the diff adds demonstrates a behavior that a name, a
parameter, a type, or a stated constraint could carry instead.
