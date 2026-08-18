# Global Claude Configuration

This file provides core guidance to Claude Code across all projects.

> **If you are reading this file with the Read tool** — typically
> because you are a subagent and your agent definition told you to
> load global rules — the `@~/` lines below are not auto-expanded for
> you the way they are at main-session startup. Read each `@~/` line
> yourself, so every reader ends up with the same always-on set. The
> plain-path lines are never loaded up front, by main session or
> subagent — each loads only on the trigger stated inline, whichever
> reader the trigger fires for.

The list below is the single canonical enumeration of the rules set,
kept as one list so a future rules file joins the fleet's diet with no
second edit point, now with per-line load mode. A file earns
`@`-expansion only when it shapes judgment continuously — its
applicability can't be recognized without the rule already in
context. A file whose applicability announces itself at a crisp
moment loads on demand instead, and its line carries a one-line
kernel so the hard rule stays available even when the procedure
doesn't load.

@~/.claude/rules/core-principles.md
@~/.claude/rules/git-workflow.md
@~/.claude/rules/escalation-discipline.md
@~/.claude/rules/label-uncertainty.md
@~/.claude/rules/communication-style.md
rules/credential-surfaces.md — read when a command fails with an
  authentication error, before you report that failure.
rules/install-discipline.md — read before running any install command,
  or when a needed tool is missing. Kernel: never install on your own
  initiative; lockfile-honoring installs only.
rules/git-recovery.md — read when a commit is rejected for missing
  signatures, a merge is requested, or a commit landed on the wrong
  branch.
rules/ask-vs-discuss.md — read before presenting a multiple-choice
  question form. Kernel: forms decide among known options, they do
  not build understanding.
rules/foreground-vs-background.md — read before continuing or
  resuming a stopped subagent. Kernel: never resume via SendMessage.
rules/code-style.md — read before writing or reviewing code. Kernel:
  your diff should be indistinguishable in style from the file it
  lands in.
rules/comment-style.md — read before writing or reviewing comments in
  code. Kernel: a comment states a constraint the code can't show —
  never provenance, next-line narration, or a correctness argument
  aimed at the reviewer.
