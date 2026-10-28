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

## Keep every other Bash call a plain command or a read-only pipeline

Every Bash call that remains is one command, or a `|` pipeline in which
no stage changes a file or other state. Judge each stage by its effect:
`xargs -0 jsonlint --quiet` only reads, so it may be a stage, while
`tee`, `sed -i`, and `xargs rm` each write, so none of them may.

An unquoted glob argument, such as `assets/*.yml`, is allowed. No other
chaining or expansion is: no `;`, `&&`, `||`, `$?`, command substitution
(`$(…)` or backticks), variable expansion, heredoc, or redirection.

When the command is `git` or a script whose name begins `git-`, give it
no argument whose last path component is `git` or a `git-` name without
a file extension, in any case. Write such a path as a quoted pathspec
glob, such as `'plugins/*-tools/bin/*-branch-sync'`, and join an option
to such a value with `=`, as in `--grep=git-branch-sync`.
