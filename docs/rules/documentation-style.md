# Documentation Style

Read before writing or reviewing a doc comment — TSDoc, JSDoc, a
Python docstring, godoc, rustdoc — or any other annotation a tool
extracts into a generated API reference.

The structure this file follows and the per-repo extension it obeys
are stated once in `docs/rules/code-style.md` → "Structure contract"
and → "Per-repo extension", and govern this file unchanged. That guide
is already in context whenever this one is: you do not write a doc
comment without writing the symbol it documents.

## Preamble (not a rule source)

A doc comment is the symbol's published contract. Its reader is a
caller who will never open the file, so it states what calling the
symbol correctly requires: what comes back, what can go wrong, and
what the caller must guarantee before calling.

The code guide's comment kernel — a comment states a constraint the
code cannot show — therefore does not govern here. A caller reading
the generated reference cannot see the code at all, so a restatement
of the signature that would be redundant to a maintainer is the entry
that reader depends on. Whether a symbol carries a doc comment at all,
and in which tag vocabulary, is a matter of fit and is settled by the
code guide's preamble.

## Rules

### Every doc comment names the symbol's failure modes

Every doc comment the diff adds or changes on a symbol that can raise,
reject, or return an error names each such outcome and the condition
that produces it.
