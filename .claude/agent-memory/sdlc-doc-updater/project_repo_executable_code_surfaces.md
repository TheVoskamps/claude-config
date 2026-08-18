---
name: repo-executable-code-surfaces
description: claude-config carries executable shell in two places — .github/scripts/ (self-tested) and install.sh/plugins.sh at the root (no tests) — so any prose claiming the scripts dir is the repo's only code is false
metadata:
  type: project
---

# This repo's executable code lives in two places

`claude-config` is mostly prose, but it carries shell in two distinct
surfaces: `.github/scripts/` (guard plus its `test-*.sh` companion)
and `install.sh` / `plugins.sh` at the repo root, which have no
companion tests and are exercised by no workflow.

**Why:** PR 50's repo-level `.claude/rules/code-style.md` preamble
asserted the repo's only executable code was "the shell under
`.github/scripts/`", to justify exempting the prose artifact from the
global test rule. The root scripts falsify that as written, so the
prose was corrected to name both surfaces and the test gap.

**How to apply:** before accepting or writing prose about what this
repo's testable surface is, list the root as well as
`.github/scripts/`. The rules/prose exemption from testing does not
reach `install.sh` or `plugins.sh` — those are ordinary code that
simply has no suite yet.
