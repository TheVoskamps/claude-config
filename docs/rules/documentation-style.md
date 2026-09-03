# Documentation Style

Read before writing or reviewing a file no computer interprets or
compiles and no session loads as instruction — a README, a changelog,
a design doc — and before writing or reviewing a doc comment: TSDoc,
JSDoc, a Python docstring, godoc, rustdoc, or any other annotation a
tool extracts into a generated API reference. That is this guide's
whole remit.

Read `<repo>/docs/rules/extensions/documentation-style.md` after this
guide when the repo you are working in carries that file; it extends
and overrides what is here, and its absence means the repo adds
nothing.

The structure this file follows is stated once in
`docs/rules/code-style.md` → "Structure contract", and governs this
file unchanged.

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

### Every Markdown file the diff touches passes the repo's markdownlint

Every Markdown file the diff touches passes the markdownlint config
the repo declares, in whole and including the lines the diff did not
change, in repos that declare one.
