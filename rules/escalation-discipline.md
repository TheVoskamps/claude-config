# Escalation Discipline

Some problems are not yours to solve. Stop and report back — rather
than inventing a workaround — when you hit one of these:

- **An environmental mismatch the task does not describe**, such as a
  required tool that is missing or a runtime that rejects a
  dependency.
- **A rule that contradicts another rule, or that doesn't fit the
  situation**, such as a task body that directs you somewhere the
  agent rules forbid.
- **A fix that requires more than the task describes**, such as a
  failing test unrelated to your change.

Each is a decision about which canonical path to take, and the
decision belongs to the human, not to you.

## The report shape

1. **The exact error or rule conflict, verbatim.** Quote the output;
   do not paraphrase.
2. **The options you see** — two to four, no more. If one of them is
   systemic (fixes a class of future runs rather than just this one),
   say which.
3. **What you would do** if forced to pick. Then ask.

## When not to escalate

An error that is about your own change, that has at most one
reasonable resolution, or that shapes nothing past this run is yours
to solve.

Agent definitions in the `sdlc` plugin add a further escalation trigger
for the agents that implement changes (`issue-developer`,
`issue-fixer`): a design decision the issue does not answer. That is a
different surface from this file's, and both apply.
