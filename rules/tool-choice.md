# Tool Choice

This rule overrides the auto-mode guidance that leaves the choice
between Bash and the dedicated file tools open: the worktree Bash guard
refuses many of the shell commands that guidance suggests.

## Read and change files with the file tools

Read a file with Read, and change one with Edit or Write. Never use
`cat`, `head`, `sed`, `awk`, a heredoc, or a redirection to read or
change a file.

## Search with Grep and Glob when the session has them

Search with the Grep and Glob tools when the session has them. Without
them, use plain `grep` and `find`.

## List directories with `ls`

Read does not open a directory, so list one with `ls`.

## Keep every other Bash call a single plain command

Every Bash call that remains is one command, with no `;`, `&&`, `$?`, or
other shell expansion: the worktree guard refuses any such call it
cannot show stays clear of git.
