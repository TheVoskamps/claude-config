# Install Discipline

Two distinct integrity concerns govern when you may install something.
Keep them separate — they have different scopes and different failure
modes:

| Axis | Protects | Forbidden action | Who is bound |
| --- | --- | --- | --- |
| **Host integrity** | The user's machine — home dir, package managers, PATH, system prefs | Global / host-wide installs (`npm install -g`, `brew install`, `pipx install`, `cargo install`, …) | Main session **and** all subagents |
| **Project dependency integrity** | The project's declared deps and lockfile | On-own-initiative `npm install <pkg>` (resolves an undeclared version, churns `package.json` / lockfile) | **Subagents only** — the main session may run this under user direction |

The two axes are independent. A `npm install -g eslint` violates host
integrity. A `npm install eslint` (no `-g`) leaves the host alone but
violates project-dependency integrity when a subagent runs it on its
own initiative. A `npm ci` violates neither and is always allowed.

When a project-local command fails, **stop and report**. Do not
improvise a recovery that touches either surface. The user will decide
whether to fix the repo (e.g. correct a bad script), install something,
or take a different path.

See also: `rules/core-principles.md` §0 ("NEVER EVER execute bash
commands that modify state without explicit approval"). This rule
extends that general principle by naming the specific classes of
install command so they survive reasoning like "but the build needs
CDK, so installing CDK is implied."

## Host integrity — forbidden for everyone

The following commands write outside the current repo/worktree and
must not be invoked on your own initiative, by the main session or by
any subagent:

- **Node**: `npm install -g`, `npm i -g`, `yarn global add`,
  `pnpm add -g`.
- **Python**: `pip install` outside the project's venv (where "in the
  venv" means either an activated venv OR an explicit invocation like
  `<venv>/bin/pip`, `uv run pip`, or `poetry run pip`);
  `pip install --user`; `pipx install`; `uv pip install` outside a
  venv.
- **macOS**: `brew install`, `brew upgrade`, `brew tap`,
  `brew uninstall`, `mas install`.
- **Ruby**: `gem install` without `--user-install`.
- **Rust / Go**: `cargo install`, `go install`.
- **Generic**: any package manager invocation that writes outside the
  current worktree.

This list is illustrative, not exhaustive. The principle is: anything
that modifies state outside the current worktree (the user's home
directory, their package managers, their PATH, their system
preferences) is forbidden as a recovery action.

## Project dependency integrity — tightened for subagents

A subagent must not improvise dependency installs to "fix" a missing
tool. The only install command a subagent may run on its own
initiative is the project's **deterministic-from-lockfile install**.
For Node that is `npm ci`. For Python that is
`pip install -r requirements.txt --no-deps` inside an active venv (or
the equivalent for `uv`, `poetry`, `pipenv`). For other languages,
the analogous lockfile-honoring install (`pnpm install --frozen-lockfile`,
`yarn install --frozen-lockfile`, `cargo build` with a committed
`Cargo.lock`, `go build` with a committed `go.sum`, etc.).

A deterministic install reads exactly what the project's lockfile
declares. No version drift, no edits to `package.json` or
`requirements.txt`, no lockfile churn, fully reproducible.

The following are forbidden as on-own-initiative recovery in a
**subagent**, even when a tool is missing and an install "obviously"
would fix it:

- `npm install <pkg>` / `npm i <pkg>` — writes to `package.json`
  and `package-lock.json`, resolves an undeclared version, drifts
  the worktree from the PR's actual state, may trigger `preinstall`
  hooks that cascade installs elsewhere.
- `pip install <pkg>` outside a venv with a pinned
  `requirements.txt` (or equivalent).
- Adding to `node_modules/`, `site-packages/`, or any project
  dependency tree by other means — downloading binaries with `curl`
  or `wget`, extracting tarballs with `tar -xf`, copying wheels in
  by hand, etc.

This list is illustrative, not exhaustive. The principle: a subagent
must not resolve an undeclared version or write outside what the
project's lockfile already authorizes.

The asymmetry is intentional: the main session runs interactively and
can ask before installing, so it may run `npm install <pkg>` under
user direction. A subagent runs autonomously and the user only sees
its output after the fact. A `npm install aws-cdk` inside a subagent
commits the worktree to a version the project never declared, and the
user finds out when the PR diff includes `package.json` and
`package-lock.json` churn that has nothing to do with the issue. By
the time it's visible it's already done.

## When a project-local command fails

1. **State the failure plainly.** Quote the verbatim error output;
   don't paraphrase.
2. **Identify the root cause** if it's evident from the error
   (e.g. "the `synth` script invokes bare `cdk` instead of `npx cdk`,
   which isn't on PATH").
3. **Report and stop.** Don't run a recovery. The user picks the fix.

This mirrors the escalation-discipline rule
(`~/.claude/rules/escalation-discipline.md`): an environmental
mismatch is a decision-point, not noise to silently solve.

### Subagent escalation message shape

When `npm ci` (or the language equivalent) does not give a subagent
the tool it needs, **stop and escalate**. Do not improvise. The
escalation message names:

1. **Which tool is missing** (`cdk`, `tsc`, `kubectl`, etc.).
2. **Which command failed** and the project's declared way to
   invoke that tool (`npm run synth`, `npx tsc`, `npm test`, etc.).
   Quote the verbatim error output; do not paraphrase.
3. **The shortest explanation** of why this isn't something the
   subagent can fix in scope. Example:

   > The project's `npm run synth` script invokes bare `cdk`; the
   > `node_modules/.bin/cdk` is installed by `npm ci` but isn't on
   > PATH for the script's subshell. The repo-side fix is to change
   > the script to `npx cdk synth` (tracked in issue #1058). I'm
   > escalating because `npm install aws-cdk` would drift the
   > project's declared deps, and `npm install -g aws-cdk` is
   > forbidden by the host-integrity axis above.

The orchestrator's job, on receiving the escalation, is to surface it
to the human verbatim. The human's options are:

- (a) Fix the project (e.g. land the repo-side script fix).
- (b) Explicitly approve an ad-hoc install for this one task. That
  approval does NOT carry over to the next task or the next tool;
  each ad-hoc install requires its own approval.
- (c) Abandon the task.

## What this rule does NOT forbid

- `npm ci`, `pnpm install --frozen-lockfile`,
  `yarn install --frozen-lockfile` — these install only what the
  lockfile declares and are the canonical path.
- `pip install -r requirements.txt` inside an active venv when the
  requirements file is part of the project. Same idea: install only
  what the project declares.
- Project-local installs by the **main session under user direction**
  (`npm install` without `-g`, `pip install` in an active venv,
  `cargo build`). These touch only the worktree, not the host.
- `npx <tool>` invocations that resolve from the project's
  `node_modules/.bin` after a clean `npm ci`. These don't install
  anything new; they run what the lockfile already brought in.
- Tool invocations the user has explicitly approved for this exact
  command earlier in the same task. (Approval of `brew install foo`
  does NOT extend to `brew install bar` — each host-touching command
  requires its own approval.)
- Running already-installed tooling. Detecting "tool X is missing" is
  fine; deciding to install it on your own initiative is not.

## Relationship to other rules

- `rules/escalation-discipline.md` describes the general shape of
  "stop and report back" for environmental mismatches. The escalation
  flow above is a specialization of that pattern for the
  dependency-install case.
- `rules/credential-surfaces.md` covers credential-agent
  introspection, not installs. The two files are parallel in style —
  "user-owned surfaces you must not touch on your own initiative" —
  but they cover different surfaces.
