# Install Discipline

Distinct integrity concerns govern when you may install something.
Keep them separate:

| Axis | Protects | Forbidden action | Who is bound |
| --- | --- | --- | --- |
| **Host integrity** | The user's machine — home dir, package managers, PATH, system prefs | An on-own-initiative install that writes outside the current worktree | Main session **and** all subagents |
| **Project dependency integrity** | The project's declared deps and lockfile | Any install other than the project's deterministic-from-lockfile install, a hand-placed artifact matching the pin included | **Every subagent on its own initiative**; a subagent may run a resolving install only under user direction, as may the main session |

The axes are independent: an install can violate either one alone.

## Host integrity — forbidden for everyone

Never run, on your own initiative, a command that changes state
outside the current worktree — the user's home directory, a host-level
package manager, their PATH, or their system preferences. Installing a
tool the task needs is the paradigm case.

A package manager you think of as project-local is still bound here
whenever the invocation writes outside the worktree: a global flag and
an unactivated virtual environment both put it on this axis.

## Project dependency integrity — tightened for subagents

On its own initiative, a subagent may run exactly one install: the
project's **deterministic-from-lockfile install** — one that resolves
no version the lockfile does not already pin, and fails rather than
resolving one.

A **resolving install** — one that writes or changes the lockfile — is
permitted when the user directed it. Direction comes from the user in
the session, or from an issue the subagent was given to implement
whose `## Files affected` section lists the lockfile tagged `new` or
`update`. A lockfile mentioned anywhere else in an issue body is not
direction.

The main session is bound the same way: on its own initiative it runs
only the deterministic-from-lockfile install, and it runs a resolving
install only under user direction.

Every other install goes to the escalation path below, whether it
comes from a package manager or from a binary, tarball, or wheel
placed into a dependency tree by hand.

## When a project-local command fails

Stop and report. Do not run a recovery: the user picks the fix.
Alongside the verbatim error, name the missing tool, the project's
declared way to invoke it, the root cause when the error makes it
evident, and which axis above forbids the install you would otherwise
have run.
