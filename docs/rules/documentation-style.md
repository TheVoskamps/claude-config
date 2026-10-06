# Documentation Style

Read before writing or reviewing Documentation.
That is this guide's whole remit.

Read `<repo>/docs/rules/extensions/documentation-style.md` after this
guide when the repo you are working in carries that file; it extends
and overrides what is here, and its absence means the repo adds
nothing.

## Preamble (not a rule source)

Prose written for a human reader is terse and self-contained, and
states no count the reader can derive from what is already shown.

## For Authors

## For Authors and Checkers

### Every Markdown file the diff touches passes the repo's markdownlint

Every Markdown file the diff touches passes the markdownlint config
the repo declares, in whole and including the lines the diff did not
change, in repos that declare one.
