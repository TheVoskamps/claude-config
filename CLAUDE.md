# Global Claude Configuration

This file provides core guidance to Claude Code across all projects.

> **If you are reading this file with the Read tool** — typically
> because you are a subagent and your agent definition told you to
> load global rules — the `@~/` lines below are not auto-expanded for
> you the way they are at main-session startup. Read each `@~/` line
> yourself, with these exceptions:
>
> - `rules/ask-vs-discuss.md` — skip; it governs interactive
>   question-asking, which a subagent does not do.
> - `rules/foreground-vs-background.md` — skip; it governs how the
>   main session resumes subagents.
>
> The list below — `@~/` lines and the plain-path line alike — is the
> canonical enumeration of the rules set.

The list below is the single canonical enumeration of the rules set,
kept as one list so a future rules file joins the fleet's diet with no
second edit point. Most lines are `@`-expanded: the main session loads
them at startup, and a subagent reads each one per the note above.
`rules/credential-surfaces.md` is the one plain-path line instead — it
is purely situational for every reader, main session included, so
loading it up front would be dead weight most sessions never touch.
Read it when a command fails with an authentication error, before you
report that failure.

@~/.claude/rules/core-principles.md
@~/.claude/rules/git-workflow.md
@~/.claude/rules/escalation-discipline.md
@~/.claude/rules/install-discipline.md
@~/.claude/rules/label-uncertainty.md
rules/credential-surfaces.md
@~/.claude/rules/ask-vs-discuss.md
@~/.claude/rules/foreground-vs-background.md
