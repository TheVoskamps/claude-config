# Comment Style

Read before writing or reviewing comments in code.

This file has two parts. The **preamble** is judgment guidance for a
human or an agent holding the whole change in its head. The **rules**
below it are the machine-consumable part: each `###` heading under
"Rules" is exactly one rule, phrased as a claim about a diff that a
single quoted counterexample refutes. A tool enumerating rules from
this file reads the `###` headings under "Rules" and nothing else.

## Preamble (not a rule source)

A comment states a constraint the code cannot show.

That is the whole kernel, and every rule below is a consequence of it.
The code already shows what it does, in a notation more precise than
English and one that cannot drift out of date. What the code cannot
show is the world outside it: the upstream API that returns `null` for
a 404 instead of raising, the ordering two functions must keep because
a third depends on it, the constant that must match a value in a
config file the compiler never sees, the obvious-looking simpler
approach that was tried and does not work.

The audience is a maintainer arriving in two years with no memory of
this change, not the reviewer reading it this week. That single
substitution settles most cases. The reviewer wants to know why you
made the change; the maintainer wants to know what will break if they
undo it. Write for the maintainer, and put what the reviewer needs in
the PR body, where it belongs.

The corollary is that most lines need no comment at all, and a file
whose comments are all constraint statements will be sparsely
commented. That is the correct outcome, not an omission to fix.

Comments are prose, so `rules/communication-style.md` → "Mechanics"
applies to them: one idea per sentence, active voice, concrete verbs.

## Rules

### No comment narrates provenance

No comment the diff adds records the history of the code rather than a
property of it: which issue or PR produced it, what it used to be, who
asked for it, when it changed, or that it was a review fix.

Counterexample shapes: `// added for issue 43`, `// changed from map
to filter`, `// per review feedback`, `// 2026-08-17 EV`.

Version control already holds all of it, more accurately and without
going stale. A tracker reference is allowed only where a rule below
explicitly requires one.

### No comment narrates the next line

No comment the diff adds restates in English what the line or block
immediately below it does. If deleting the comment loses no
information a reader could not recover by reading the code, the
comment is narration.

Counterexample shapes: `// increment the counter` above `count += 1`;
`# loop over the users` above a `for user in users:`; a docstring
whose entire body re-spells the function name and parameter names.

### No comment argues correctness to the reviewer

No comment the diff adds defends the change to whoever is reviewing
it: assertions that the code is safe, correct, tested, or equivalent
to what it replaced, addressed at the reader of the diff rather than
the reader of the file.

Counterexample shapes: `// this is safe because the caller already
checked`, `// equivalent to the old behaviour`, `// covered by the new
test`.

A comment naming a constraint a future maintainer must not violate is
not this, even when it explains why. The distinguishing question: does
the comment still make sense to someone who never saw this diff? If it
does, it is a constraint. If it only makes sense next to the change,
it belongs in the PR body.

### No comment is commented-out code

No comment the diff adds is disabled source: an old implementation,
a debug statement, an alternative approach, or a block kept "in case
we need it".

Counterexample shape: a fenced block of former implementation left
above its replacement.

### No comment contradicts the code it sits on

No comment the diff leaves in place — added or pre-existing on a line
the diff changes — makes a claim the code around it no longer
satisfies: a stale parameter name, a stale return description, a
stale invariant, a stale count of the things below it.

Counterexample shape: a docstring listing three parameters above a
function the diff cut to two.

### Comment density matches the surrounding file

No file the diff touches gains a comment-to-code ratio materially
above the ratio the untouched parts of that same file already carry.

Counterexample shape: a densely commented new function added to a file
whose existing functions carry no comments at all.

A file with no comments is making a claim about how much explanation
its code needs. Match it, or change the file's convention deliberately
and say so in the PR body.

### Every TODO carries a tracker reference

Every `TODO`, `FIXME`, `HACK`, or `XXX` marker the diff adds names the
tracker issue that will resolve it.

Counterexample shape: a bare `// TODO: handle the retry case`.

This is the one place a tracker reference belongs in a comment: the
marker is a pointer to future work rather than a record of past work,
so it is a constraint on the code as it stands, not provenance.

### Doc comments follow the file's existing convention

For every public symbol the diff adds, the presence and shape of a doc
comment matches what the other public symbols in the same file already
have — docstring style, tag vocabulary, and whether they are present
at all.

Counterexample shape: a JSDoc block with `@param` tags added to a file
whose other exports carry no doc comments.

## Per-repo extension

A repo extends or overrides this guide with
`<repo>/.claude/rules/comment-style.md`, tracked by the same
`.gitignore` negation pattern that tracks
`<repo>/.claude/rules/repo-config.md`.

Resolution is global-then-repo: this file first, the repo file
appended as extension and override. Where the two conflict, the repo
file wins — it is the more specific statement about the code actually
in front of you.

The repo file follows the same structure as this one: one rule per
heading, each rule a claim about a diff that a quoted counterexample
refutes, judgment-only guidance confined to a marked preamble. A tool
reads the concatenation, so a repo file that drops the structure makes
its own rules unreadable to that tool.
