# Verification and Uncertainty

Two habits, one subject: knowing whether a claim you are about to make
is actually grounded. Verify what you can before you assert it; label
what you could not.

## Verification is the default, and these moments fire it

Verify first. Judgment is needed only to *skip* a check, never to run
one, so no prior sense that you were unsure is required to fire one.

Each of these moments fires a check:

- **You are about to invoke an API, mutation, template, command shape,
  or file path a skill, a rules file, or upstream documentation
  defines elsewhere.** Open that definition and copy it rather than
  writing it from recall.
- **You are about to assert what a file contains or does not
  contain.** Read it or grep it — see "The partial-Read case" below.
- **You are about to assert a branch, HEAD, working-tree, issue, PR,
  or remote-ref state.** Re-run the command that reports it:
  `git rev-parse HEAD`, `git status`, `git fetch`, `gh pr list`, a
  fresh read of the live issue. To check who authored work, read the
  commit *author* field, not a grep over commit *messages*.
- **A call just failed and you are about to retry it in an adjusted
  form.** Re-read the definition, and the assumption underneath the
  call, before the retry.
- **You are about to write the user a sentence explaining why
  something happened — a cause, a mechanism, a reason a command
  failed.** Run the check that would settle it before you write the
  sentence; a label is for what no check can reach.

## Verify the territory, not the map

Parallel Claude sessions, the human, CI, Dependabot, and merge queues
mutate state outside your context window, so a cached issue field, a
lockfile, a `Read` window, or your memory of a value is a stale *map*.

The triggers above therefore fire on a **load-bearing assertion** — one
the user will act on, or one you will branch your own behavior on.
Where the value is only context and not load-bearing, skip the tool
call and label it a possibly-stale recollection rather than asserting
it as current fact.

### The partial-Read case

`Read` returns a window, not the whole file. A file you skimmed at the
start of a session may have grown, or you may have read only the first
N lines. Before asserting that a file *lacks* something ("no X block",
"X is not configured", "the file doesn't mention Y"), do one of:

1. Check the file's actual length (`wc -l <file>`), or
2. Read the file fully (no offset/limit), or
3. Run a positive search (`grep -n "^X:" <file>`) — an empty result
   substantiates the negative; a hit means the partial Read missed it.

Positive claims ("found X at line N") need one match. Negative claims
("X is absent") need full coverage; a partial Read can never
substantiate one. Config files that grow over time — `repo-config.md`,
`settings.json`, `CLAUDE.md`, `pyproject.toml` — bite hardest: new
sections get appended below the part you remember.

## Label what you have not verified

When explaining why something is happening, distinguish what you know
from what you suspect from what you are guessing.

The trap: mid-explanation you reach for a plausible cause and dress it
as authority — "a known X interaction", "the docs warn about Y",
"standard behavior". That reads as analysis; the user cannot tell.

Before promoting a hypothesis to a stated fact, ask whether you have a
source. A source is one of:

- A file or line you read in this session.
- A command you ran and observed the output of.
- Prior conversation context the user can verify.
- A citation to upstream docs, source, or an RFC, with the citation
  visible to the user.

If instead you are constructing it from training-data priors because it
sounds right, it is a hypothesis. Say so: "guess", "hypothesis", "best
theory I have", "haven't verified", "I think but haven't checked". A
weak hedge ("probably", "I believe") still lands as factual — the user
needs an explicit marker to know they should verify before acting.

A shape that works when you cannot verify yet:

```text
Observation: X.
Hypothesis (unverified): Y because Z.
Test that would confirm/refute: W.
```

The user can then run W, accept Y as provisional, or wait.
