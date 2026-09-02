# Code Style — this repo

## Preamble (not a rule source)

The files this guide reaches here are the shell scripts — `install.sh`
and `plugins.sh` at the repo root, and the scripts under
`.github/scripts/` — the workflows under `.github/workflows/`, and the
JSON configs a tool parses: `settings.json` and `keybindings.json`,
which the harness reads, and the `.markdownlint.jsonc` files, which
markdownlint reads.

Under `.github/scripts/` the global test rule fires in full, because a
self-test already covers that surface, and the rule below says so.
`install.sh` and `plugins.sh` carry no test suite, so the global
rule's own "in repos that already have a test suite for that surface"
clause leaves them out — a gap, not a licence to break them.

## Rules

### Every script under `.github/scripts/` has a self-test

Every executable script the diff adds or changes under
`.github/scripts/` has a companion `test-<name>.sh` beside it that
exercises the changed behavior, and the companion covers the new case
the diff introduces.

This is where the global test rule bites in this repo. The existing
pair is the precedent: the guard's self-test builds throwaway git
repos and asserts the guard's exit code.
