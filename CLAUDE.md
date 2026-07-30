# Global Claude Configuration

This file provides core guidance to Claude Code across all projects.

> **If you are reading this file with the Read tool** — typically
> because you are a subagent and your agent definition told you to
> load global rules — the `@~/` lines below are not auto-expanded for
> you the way they are at main-session startup. Read them yourself,
> with these exceptions:
>
> - `rules/credential-surfaces.md` — do not read up front. Read it
>   when a command fails with an authentication error, before you
>   report that failure.
> - `rules/ask-vs-discuss.md` — skip; it governs interactive
>   question-asking, which a subagent does not do.
> - `rules/foreground-vs-background.md` — skip; it governs how the
>   main session resumes subagents.
>
> The `@~/` lines are the canonical enumeration of the rules set. Read
> every one not named above.

All rules files stay `@`-expanded for the main session: it is the one
reader that may need any of them, and a rule the main session has to
remember to load is a rule it will skip. Scoping happens inside each
file instead — every situational file opens by naming who it is for
and when it applies, which keeps this list the single enumeration and
lets a subagent follow the exceptions above without a second index to
maintain.

@~/.claude/rules/core-principles.md
@~/.claude/rules/git-workflow.md
@~/.claude/rules/escalation-discipline.md
@~/.claude/rules/install-discipline.md
@~/.claude/rules/label-uncertainty.md
@~/.claude/rules/credential-surfaces.md
@~/.claude/rules/ask-vs-discuss.md
@~/.claude/rules/foreground-vs-background.md
