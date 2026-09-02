# Documentation Style

Read before writing or reviewing a file no computer interprets or
compiles and no session loads as instruction — a README, a changelog,
a design doc — and before writing or reviewing a doc comment: TSDoc,
JSDoc, a Python docstring, godoc, rustdoc, or any other annotation a
tool extracts into a generated API reference. That is this guide's
whole remit.

The structure this file follows and the per-repo extension it obeys
are stated once in `docs/rules/code-style.md` → "Structure contract"
and → "Per-repo extension", and govern this file unchanged.

## Preamble (not a rule source)

Prose written for a human reader is terse and self-contained, and
states no count the reader can derive from what is already shown.

A doc comment is the symbol's published contract. Its reader is a
caller who will never open the file, so it states what calling the
symbol correctly requires: what comes back, what can go wrong, and
what the caller must guarantee before calling.

A caller reading the generated reference cannot see the code at all,
so a restatement of the signature that would be redundant to a
maintainer reading the file is the entry that reader depends on.

## Rules

### Every doc comment names the symbol's failure modes

Every doc comment the diff adds or changes on a symbol that can raise,
reject, or return an error names each such outcome and the condition
that produces it.
