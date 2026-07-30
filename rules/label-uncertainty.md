# Verification and Uncertainty

Two habits, one subject: knowing whether a claim you are about to make
is actually grounded. The first is about re-reading state that may have
moved. The second is about labelling claims you never verified at all.

## Verify the territory, not the map

Before a **load-bearing assertion** — one the user will act on, or one
you will branch your own behavior on — ask whether the value came from
your own context or from a surface something else can write. Your
context is a snapshot from when you last looked; the world kept moving.

Much of the state you reason about is mutated outside your context
window by independent writers: parallel Claude sessions, the human, CI,
Dependabot, merge queues. A representation of that state — a cached
issue field, a CI badge, a lockfile, a `Read` window, your own memory
of a value — is a *map*. The underlying state is the *territory*.

When an assertion is load-bearing and the value is one a separate
writer can change, spend one tool call to re-read the territory before
asserting. Specifically volatile surfaces:

- **GitHub issue / PR state** — re-read the live issue or the merged
  PR, not the status you saw earlier in the session.
- **The current local branch, HEAD, the working tree** — run
  `git rev-parse HEAD` / `git status`, don't trust your memory of what
  branch you switched to.
- **Remote refs, open PRs** — `git fetch` / `gh pr list`, not a cached
  list.
- **Authorship vs. message body** — to check who authored work, read
  the commit *author* field, not a grep over commit *messages*.

If the value is only for context and not load-bearing, skip the extra
tool call — but label it as a possibly-stale recollection rather than
asserting it as current fact.

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
substantiate one. This bites hardest on config files that grow over
time (`repo-config.md`, `settings.json`, `CLAUDE.md`,
`pyproject.toml`, `.env`), where new sections get appended below the
part you remember.

## Label what you have not verified

When explaining why something is happening, distinguish what you know
from what you suspect from what you are guessing.

The trap: mid-explanation you reach for a plausible-sounding cause, and
the instinct is to make it sound authoritative — "this is a known X
interaction", "the docs warn about Y", "standard behavior". That reads
as analysis but is confident speculation. The user cannot tell the
difference in your output, and builds the next decision on it. When the
speculation is wrong, the error surfaces only when reality contradicts
it, often after budget has been spent acting on the wrong model.

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

When acting on the hypothesis is cheap and the user is about to make a
decision on it, just verify instead. Two tool calls beat an hour spent
on a wrong model.

A shape that works when you cannot verify yet:

```text
Observation: X.
Hypothesis (unverified): Y because Z.
Test that would confirm/refute: W.
```

The user can then run W, accept Y as provisional, or wait.
