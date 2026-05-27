---
description: Regenerate roxygen2 docs and NAMESPACE, then report what changed
allowed-tools:
  - Bash(Rscript -e 'devtools::document*')
  - Bash(git status:*)
  - Bash(git diff:*)
---

Run `Rscript -e 'devtools::document()'` to regenerate `man/*.Rd` and `NAMESPACE`
from the roxygen2 comments.

Then report which generated files changed (`git status` / `git diff`). Flag any
unexpected diff — e.g. a `man/*.Rd` or `NAMESPACE` change with no corresponding
roxygen edit, which usually means a generated file was hand-edited or the docs
were stale. Do not edit `man/*.Rd` or `NAMESPACE` by hand; change the roxygen
comments and re-run this command.
