# Escalation Discipline

Some problems are not yours to solve. Stop and report back — rather
than inventing a workaround — when you hit one of these:

- **An environmental mismatch the task does not describe.** The host
  Python rejects a dependency, the deployment target's runtime differs
  from the host's, a required tool is missing, a credential has
  expired, a base image won't pull, a port is occupied.
- **A rule that contradicts another rule, or that doesn't fit the
  situation.** The task body tells you to write to `/tmp/` but the
  agent rules forbid it; a rule says "verify in a venv" but the host
  can't build the deps.
- **A fix that requires more than the task describes.** The failing
  test is unrelated to your change; a wheel build breaks for reasons
  that have nothing to do with the version bump you were asked for.

These are not implementation noise to solve and move on from. Each is a
decision about which canonical path to take, and the answer shapes
every future run — so the human needs to see it in real time.

## The report shape

This is the canonical shape for every stop-and-report in this rules
set. Other rules reference it rather than restating it.

1. **The exact error or rule conflict, verbatim.** Quote the output;
   do not paraphrase.
2. **The options you see** — two to four, no more. If one of them is
   systemic (fixes a class of future runs rather than just this one),
   say which.
3. **What you would do** if forced to pick. Then ask.

`rules/credential-surfaces.md` narrows this shape for authentication
failures, where naming a remediation is itself out of bounds.

## When not to escalate

You do not need to escalate every error. All three of these must hold:

- The error is *not* about the fix you're working on, so it isn't your
  change that's wrong.
- The problem has *more than one reasonable resolution*, so picking
  one silently makes a non-trivial decision on the human's behalf.
- The resolution would *shape future runs*, not just this one.

Routine errors that fail any of those — a typo you made, a test you
broke, a lint error in your own diff — you keep solving yourself.

Agent definitions in the `sdlc` plugin add a further escalation trigger
for the agents that implement changes (`issue-developer`,
`issue-fixer`): a design decision the issue does not answer. That is a
different surface from this file's, and both apply.
