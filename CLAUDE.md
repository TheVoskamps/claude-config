# Global Claude Configuration

> **Reading this file with the Read tool?** The `@~/` lines below are
> not auto-expanded for you — read each one yourself.

@~/.claude/rules/core-principles.md
@~/.claude/rules/git-workflow.md
@~/.claude/rules/escalation-discipline.md
@~/.claude/rules/human-turn.md
@~/.claude/rules/label-uncertainty.md
docs/rules/credential-surfaces.md — read when a command fails with an
  authentication error, before you report that failure. Kernel: never
  probe or manipulate the user's credential agents — report the
  failure with its error verbatim and ask.
docs/rules/install-discipline.md — read before running any install
  command, or when a needed tool is missing. Kernel: never install on
  your own initiative; lockfile-honoring installs only.
docs/rules/git-recovery.md — read when a commit is rejected for missing
  signatures, a merge is requested, or a commit landed on the wrong
  branch. Kernel: never squash merge, and never merge the default
  branch into another — rebase the other branch onto it instead.
docs/rules/code-style.md — read before writing or reviewing a file a
  computer interprets or compiles — source in any language, a shell
  script, a build file, a config a tool parses — and the inline
  comments in it. Kernel: your diff should be indistinguishable in
  style from the code it lands in, and a comment states a constraint
  the code cannot show.
docs/rules/documentation-style.md — read before writing or reviewing a
  file no computer interprets or compiles and no session loads as
  instruction (a README, a changelog, a design doc), or a doc comment:
  TSDoc, JSDoc, a docstring, or any other annotation a tool extracts
  into a generated API reference. Kernel: a doc comment is the symbol's
  published contract, written for a caller who will never open the
  file.
docs/rules/claude-code-markdown-instructions-style.md — read before
  writing or reviewing Markdown a model loads as instructions:
  `CLAUDE.md`, files under `rules/` and `docs/rules/`, `SKILL.md`
  bodies, agent definitions, output styles. Kernel: a line earns its
  place only when a reader acts differently for having read it and the
  condition that put it there is still real, which is as much a licence
  to delete as a test for what you add.
