---
description: Run the testthat suite and report failures
allowed-tools:
  - Bash(Rscript -e 'devtools::test*')
---

Run `Rscript -e 'devtools::test()'` to run the full testthat suite.

Report any failing or warning tests, grouped by test file, including:

- The test description and file
- The expectation that failed and the observed vs. expected value
- A one-line suggestion for the likely cause

For snapshot/`vdiffr` failures, note whether the change looks intentional (a
deliberate plot change needing a snapshot update) or a regression. If everything
passes, say so and report the test count.
