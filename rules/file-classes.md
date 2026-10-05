# File Classes

## A file is exactly one of three classes, decided by its run-time use

Every file is exactly one class, decided by how it is used at run time
and never by its name or location:

- **Instruction Markdown** — Markdown a model loads as instructions,
  whether a session auto-loads it or another instruction file directs
  the model to read it.
- **Documentation** — a file no computer interprets or compiles and no
  session loads as instruction, such as a changelog or a design doc.
- **Code** — a file a computer interprets or compiles and no session
  loads as instruction, such as source in any language, a shell script,
  a build file, or a config a tool parses, every comment in it included.

## A repo's own account of its paths settles the class

Where a repo's instruction files describe how its paths are used at run
time, that description settles the class of the files on those paths.
