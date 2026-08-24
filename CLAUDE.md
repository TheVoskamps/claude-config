# Global Claude Configuration

> **Reading this file with the Read tool?** The `@~/` lines below are
> not auto-expanded for you — read each one yourself.

Applicability decides the directory and the directory decides the load
mode: an always-on file belongs in `rules/`, an on-demand file in
`docs/rules/`, and an on-demand entry carries the trigger and kernel
that `docs/rules/claude-code-markdown-instructions-style.md` →
"Every on-demand file is reachable by a trigger and a kernel"
requires. Every entry below names its own file's path, so a plain-path
entry still naming `rules/` marks a file whose move has yet to land.

@~/.claude/rules/core-principles.md
@~/.claude/rules/git-workflow.md
@~/.claude/rules/escalation-discipline.md
@~/.claude/rules/label-uncertainty.md
@~/.claude/rules/communication-style.md
rules/credential-surfaces.md — read when a command fails with an
  authentication error, before you report that failure. Kernel: never
  probe or manipulate the user's credential agents — report the
  failure with its error verbatim and ask.
rules/install-discipline.md — read before running any install command,
  or when a needed tool is missing. Kernel: never install on your own
  initiative; lockfile-honoring installs only.
rules/git-recovery.md — read when a commit is rejected for missing
  signatures, a merge is requested, or a commit landed on the wrong
  branch. Kernel: never squash merge, and never merge the default
  branch into another — rebase the other branch onto it instead.
rules/ask-vs-discuss.md — read before presenting a multiple-choice
  question form. Kernel: forms decide among known options, they do
  not build understanding.
rules/code-style.md — read before writing or reviewing code, where
  code includes prose that instructs an agent (rules files, skills,
  agent definitions); also before writing or reviewing any file the
  repo declares a formatter or linter for. Kernel: your diff should be
  indistinguishable in style from the file it lands in.
rules/comment-style.md — read before writing or reviewing comments in
  code, where code includes prose that instructs an agent (rules
  files, skills, agent definitions); also before writing or reviewing
  comments in any file the repo declares a formatter or linter for.
  Kernel: a comment states a constraint the code cannot show.
docs/rules/claude-code-markdown-instructions-style.md — read before
  writing or reviewing markdown whose reader is a model: `CLAUDE.md`,
  rules files, `SKILL.md` bodies, agent definitions. Kernel: a line
  earns its place only when a reader acts differently for having read
  it and the condition that put it there is still real, which is as
  much a licence to delete as a test for what you add.
