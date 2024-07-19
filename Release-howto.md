# Release howto

This is a howto and a checklist for preparing a cc64 release.

Assumed starting point is that all intended source code changes and ideally all
corresponding documentation changes are already submitted but the binaries
are still in the old or possibly an intermediate state, and
[`version.fth`](src/common/version.fth) hasn't been changed yet.

* If the new version shall be based on a new VolksForth version, preferably
  first run the tests (see next point), then run `./forth/update-forth.sh`.
  If cc64 using the old VolksForth is broken, then the pre-update test run
  will usually be skipped.
* Run the tests:
    * `make fasttests` runs the combinded test suites for each platform without
      cross-compiling.
    * Not really needed at this point yet: `make slowtests` runs the combinded
      test suites and the individual e2e tests for each platform without
      cross-compiling.
* Commit the 3 updated binaries in `forth/` and the `vf-build-base` binaries
  and .T64 autostart files.
* It's a good idea to start or have started the new version's description in
  `Versions.md` at this point.
* Update `src/common/version.fth` and check whether the year in
  `src/common/init-shell.fth` also needs updating. Commit those changes.
* `make clean`
* `make all` - this will build the binaries.
* Run `make fasttests` again; the updated version and year should be easily
  visible during the e2e tests.
    * Further tests that could be run here:
    * `make slowtests` runs the combinded test suites and the individual
    e2e tests for each platform without cross-compiling.
    * `make fastcrosstests` runs the combinded test suites cross-compiled
    between all platforms.
    * `make slowcrosstests` runs the combinded test suites and the individual
    e2e tests cross-compiled between all platforms. This takes really long.
* If all tests pass, commit the binaries, as well as the *.T64 files.
* Run `./register-sizes.sh vX.YZ release` with X.YZ replaced by the new
  version. Commit the changed files in `bin-size-register/`, checking the
  size changes.
* Run `make proftests` to profile the new version.
* Run `./tests/e2e/register-profiles.sh vX.YX` with X.YZ replaced by the new
  version.
* Commit changed zip and d64 files.
* Review and finalize new version description in `Versions.md`. This will also
  become the release description on GitHub. Commit `Versions.md`.
* Run `git push origin` to push changes to GitHub.
* Create release on GitHub.
* 