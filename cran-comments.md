## Resubmission

rwicc was archived on CRAN on 2026-01-30 because it imported 'pryr', which
had itself been archived. This version removes that dependency: the single
use of `pryr::mem_used()` is replaced with `lobstr::mem_used()`. The package
no longer depends on any archived package, so it should once again pass CRAN's
checks.

This release also adds a few plotting helpers and fixes some minor internal
issues (see NEWS.md).

## R CMD check results

0 errors | 0 warnings | 1 note

The remaining NOTE is the expected CRAN-incoming-feasibility note for a
package returning after archival:

* New submission
* Package was archived on CRAN (archived 2026-01-30 as it required the
  archived package 'pryr', which is no longer a dependency).

The CRAN-incoming check may also flag two URLs in README.md as "possibly
invalid":

* <https://doi.org/10.1111/biom.13472> — the canonical DOI for the cited
  paper. The publisher (Wiley) returns 403 to automated requests, but the
  link resolves normally in a browser.
* the CRAN-checks badge link
  (https://cran.r-project.org/web/checks/check_results_rwicc.html) — this
  currently 404s only because the package is archived; it will resolve once
  the package is back on CRAN.

## Test environments

* local macOS, R release
* win-builder (devel and release)
* R-hub (Linux, Windows, macOS)
* GitHub Actions: macOS, Windows, and Ubuntu (devel / release / oldrel-1)

## Downstream dependencies

There are no reverse dependencies.
