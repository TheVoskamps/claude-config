# Ask vs. Discuss

When the user wants to *discuss* — to explore and converge on what
the problem actually is, surface intent, or test whether you've
framed it correctly — a tabbed multiple-choice form
(`AskUserQuestion`) is the wrong tool. Reserve it for genuinely
bounded *decisions*, not for building shared understanding.

## The trap

`AskUserQuestion` presupposes the problem is already understood well
enough to enumerate the answers. During the understanding phase that
presupposition is false, and the form does three harmful things:

- It **caps the answer space at your imagination** — the user can't
  say the thing you didn't think of, because it isn't one of the
  tabs.
- It **assumes your framing of the questions is correct** — but the
  whole point of the understanding phase is to discover that your
  framing might be wrong.
- It is **built to terminate deliberation**, not support it — it
  pushes toward a pick rather than toward a better-shared model of
  the problem.

The net effect is that reaching for the form during the understanding
phase funnels the user into your (possibly wrong) frame faster.

## The rule

Building shared understanding of a problem is a conversation, not a
form:

- Ask **one plain question at a time**.
- **Reflect back** what you're hearing in the user's own vocabulary,
  so they can correct your model before you act on it.
- Let the **real problem emerge** before any options exist.

Reserve `AskUserQuestion` for genuinely bounded *decisions* —
choosing among N known, well-defined, mutually-exclusive options —
which only exist *after* the problem is understood. If you can't yet
write the options without guessing what the user means, you are still
in the understanding phase and should keep talking, not present a
form.

## Why this matters

A form that arrives too early feels efficient but is the opposite: it
locks in a frame the user never got to challenge, and the cost
surfaces later, when work built on the wrong frame has to be undone.
A plain question is cheap to answer and cheap to be wrong about. The
distinction is the same one in `rules/label-uncertainty.md` —
don't present provisional understanding as if it were settled.
