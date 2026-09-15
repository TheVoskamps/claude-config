# Code Style — this repo

## For Authors

### Every script under `.github/scripts/` has a self-test

Every executable script the diff adds or changes under
`.github/scripts/` has a companion `test-<name>.sh` beside it that
exercises the changed behavior, and the companion covers the new case
the diff introduces.

## For Authors and Checkers
