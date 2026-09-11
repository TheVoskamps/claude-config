# Claude Code Markdown Instructions Style

Read before writing or reviewing Markdown a model loads as
instructions: `CLAUDE.md`, files under `rules/` and `docs/rules/`,
`SKILL.md` bodies, agent definitions, output styles, and any other
prose a session loads as instruction. That is this guide's whole
remit, and it covers those files whole — what earns a place in them,
how much of it there should be, and the shape and linting of what
lands.

Read
`<repo>/docs/rules/extensions/claude-code-markdown-instructions-style.md`
after this guide when the repo you are working in carries that file; it
extends and overrides what is here, and its absence means the repo adds
nothing.

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

## No instruction contradicts one stated in the same context

No instruction the diff adds contradicts one already reachable in the
same context — elsewhere in the same file, in another file the session
loads, or in the tool description of the tool it governs. The diff that
introduces the better rule also changes the one it disagrees with.

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
load it and a one-sentence statement of its hardest rule. A
routing-table entry carries that trigger and that kernel and no
justification.

## `CLAUDE.md` stays under 200 lines

Every `CLAUDE.md` the diff touches is under 200 lines afterwards, or
the diff does not lengthen it — a file already past target takes an
append only as part of a relocation or a displacement.

## `CLAUDE.md` holds purpose, gotchas, and a routing table

Every line the diff adds to a `CLAUDE.md` states what the repo is for,
states a gotcha it carries, or routes a reader to the file holding the
rest. A convention goes in a rules file the routing table reaches.

## Memory stays out of the instruction files

No line the diff adds to `CLAUDE.md` or any other instruction file
records memory — session lore, a transient fact a single run turned
up, a preference picked up along the way. Memory lives outside these
files, and durability separates the two: a fact that held only for the
run that found it is memory, while one that holds for every later
reader earns its place only if it also passes the retention test.

## No example teaches what an interface can state

No example the diff adds demonstrates a behavior that a name, a
parameter, a type, or a stated constraint could carry instead.

## Every Markdown file the diff touches passes the repo's markdownlint

Every Markdown file the diff touches passes the markdownlint config
the repo declares, in whole and including the lines the diff did not
change, in repos that declare one.

## No section moved out of an instruction file leaves a stub behind

For every section the diff removes from one instruction file and adds
to another, the source file retains nothing of it: no stub heading, no
one-line kernel, no "moved to X" pointer.

## An instruction file with no section heading uses `##` headings

Every Markdown file the diff adds or flattens whose instructions sit
directly under the `#` title carries each of those instructions as a
`##` heading.
