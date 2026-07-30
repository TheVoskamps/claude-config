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

This file is the detail behind the install carve-out in
`rules/core-principles.md` §1. It names the specific classes of
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

Stop and report, per the report shape in
`rules/escalation-discipline.md`. Do not run a recovery: the user
picks the fix. Alongside the verbatim error, name the root cause when
the error makes it evident, the missing tool, and the project's
declared way to invoke it.

What that adds up to in the common case — `npm ci` (or the language
equivalent) ran, and the tool still isn't there:

> The project's `npm run synth` script invokes bare `cdk`; the
> `node_modules/.bin/cdk` is installed by `npm ci` but isn't on PATH
> for the script's subshell. The repo-side fix is to change the script
> to `npx cdk synth` (tracked in issue #1058). I'm escalating because
> `npm install aws-cdk` would drift the project's declared deps, and
> `npm install -g aws-cdk` is forbidden by the host-integrity axis
> above.

An orchestrator receiving such an escalation surfaces it to the human
verbatim. The human can fix the project, approve an ad-hoc install for
this one task, or abandon the task. An ad-hoc approval covers that one
command only — it does not carry to the next tool or the next task.

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

`rules/credential-surfaces.md` is this file's sibling: same shape
("user-owned surfaces you must not touch on your own initiative"),
different surface. It covers credential agents, not installs.
