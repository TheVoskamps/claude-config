# Tool Choice

This rule overrides the auto-mode guidance that leaves the choice
between Bash and the dedicated file tools open.

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

Every Bash call that remains is one command, fed by no pipe or heredoc,
and with no `;`, `&&`, `$?`, or other shell expansion.

When the command is `git` or a script whose name begins `git-`, give it
no argument whose last path component is `git` or a `git-` name without
a file extension, in any case. Write such a path as a quoted pathspec
glob, such as `'plugins/*-tools/bin/*-branch-sync'`, and join an option
to such a value with `=`, as in `--grep=git-branch-sync`.
