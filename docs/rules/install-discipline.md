# Install Discipline

Distinct integrity concerns govern when you may install something.
Keep them separate — they have different scopes and different failure
modes:

| Axis | Protects | Forbidden action | Who is bound |
| --- | --- | --- | --- |
| **Host integrity** | The user's machine — home dir, package managers, PATH, system prefs | Any install that writes outside the current worktree | Main session **and** all subagents |
| **Project dependency integrity** | The project's declared deps and lockfile | An on-own-initiative install that resolves a version the lockfile does not already pin | **Subagents only** — the main session may run one under user direction |

The axes are independent. `npm install -g eslint` violates host
integrity. `npm install eslint` leaves the host alone but violates
project dependency integrity when a subagent runs it on its own
initiative. `npm ci` violates neither and is always allowed.

## Host integrity — forbidden for everyone

Never run, on your own initiative, a command that changes state
outside the current worktree — the user's home directory, a host-level
package manager (`brew`, `mas`, `gem`, `cargo`, `go`, `pipx`, …),
their PATH, or their system preferences. Installing a tool the task
needs is the paradigm case.

These forms stay spelled out, because each reads as project-local:

- `npm install -g`, `npm i -g`, `pnpm add -g`, `yarn global add` —
  the global flag on an otherwise project-local package manager.
- `pip install` with no venv active, `pip install --user`, and
  `uv pip install` outside a venv. "Inside the venv" means an
  activated venv or an explicit `<venv>/bin/pip`, `uv run pip`, or
  `poetry run pip`; nothing else counts.

## Project dependency integrity — tightened for subagents

The only install a subagent may run on its own initiative is the
project's **deterministic-from-lockfile install**: `npm ci`,
`pnpm install --frozen-lockfile`, `yarn install --frozen-lockfile`,
`cargo build` against a committed `Cargo.lock`, or
`pip install --require-hashes -r requirements.txt`. The list is
closed — an install it does not name goes to the escalation path
below, and every other `pip install` form is among them, `--no-deps`
or not. `--require-hashes` is what earns the Python member its place:
it makes pip demand a hash for every dependency, transitive ones
included, and pinned to a URL, a path, or `==`, so an unpinned
requirements file fails the install rather than resolving a version.
`--no-deps` only suppresses transitive resolution, leaving the
top-level version free to drift.

Anything that resolves a version the lockfile does not already pin is
forbidden as recovery, even when a tool is missing and an install
"obviously" would fix it — whether it comes from a package manager or
from a binary, tarball, or wheel placed into `node_modules/`,
`site-packages/`, or any other dependency tree by hand.

## When a project-local command fails

Stop and report. Do not run a recovery: the user picks the fix.
Alongside the verbatim error, name the missing tool, the project's
declared way to invoke it, the root cause when the error makes it
evident, and which axis above forbids the install you would otherwise
have run.

An orchestrator receiving such an escalation surfaces it to the human
verbatim. The human can fix the project, approve an ad-hoc install for
this one task, or abandon the task.

## What this rule does NOT forbid

Running tooling that is already installed, including an `npx <tool>`
invocation that resolves from the project's `node_modules/.bin` after
a clean `npm ci`. Detecting that a tool is missing is fine; deciding
to install it on your own initiative is not.
