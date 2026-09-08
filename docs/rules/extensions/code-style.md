# Code Style — this repo

## Preamble (not a rule source)

`install.sh` and `plugins.sh` carry no test suite, so the global test
rule's own "in repos that already have a test suite for that surface"
clause leaves them out — a gap, not a licence to break them.

## Rules

### Every script under `.github/scripts/` has a self-test

Every executable script the diff adds or changes under
`.github/scripts/` has a companion `test-<name>.sh` beside it that
exercises the changed behavior, and the companion covers the new case
the diff introduces.
