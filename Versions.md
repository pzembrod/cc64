# cc64 versions

## v0.10-dev

ANSI style function definitions are now possible.
There's no matching or checking, however,
of declared parmeter types
in the function definition and actual parmeter
types in calls to that function.

Also more parser unit tests, some bug fixes,
and binary sizes are now tracked in
[bin-size-register](bin-size-register).

A start has been made to port parts of PDCLib to cc64, incl. tests.
So far there is most of <string.h>, available in precompiled runtime
modules libc-*.[hio], to be used instead of rt-*.[hio].

Naming scheme for the basic runtime libraries rt-*.[hio] now includes
both start and end address, to facilitate version e.g. using the RAM
under the BASIC ROM on the C64.

## v0.9

Main topic of v0.9 is compile speed. With the help of a simple profiler
I was able to optimize a few performance hotspots in the scanner and in
the scanner/parser interface, resulting in more than 20% compile time
saved or more than 30% speed gained.

Also, Source code listing during compile can now be switched on and off.
Default is off; it turns out that switching off listing decreases
compile time by another ~10%.

## v0.8.1

v0.8.1 brings fixes for 2 bugs around declaring and exporting symbols for new runtime libraries. Thanks to buzzphp for finding and reporting them.

Also following a suggestion from buzzphp, v0.8.1 contains a zip file with cc64's Fourth sources in PETSCII format, plus the VolksForth kernels for C64, C16 and X16, to facilitate recompiling cc64 from source in case the Makefile setup doesn't work, e.g. on emulators under Windows or on real machines.

And finally this release contains improved testing, namely integration tests for the library symbol export, and the first unit tests for scanner and parser.

## v0.8.0.1

No code changes, just a small update to COPYING, and COPYING is added
to the distribution zip files and images.

## v0.8

v0.8 brings cc64 to the [Commander X16](https://www.commanderx16.com/).
This required a number of refactorings and the move to VolksForth 3.9.2
as build base, but no feature changes beyond that.

The build process now produces compile logs during the
build of cc64 that are verified afterwards.

## v0.7.1

In cc64 v0.7, the C16/Plus4 disk image c16files.d64 mistakenly held the C64 binaries instead of the correct C16 binaries.
V0.7.1 fixes this.

## v0.7

v0.7 is the first properly defined version, with a git label and a github
release.

v0.7 brings two major changes: a new build base, and a C16/Plus4 port.

The build base has been updated from my custom C64 UltraForth 3.82 version to
[VolksForth](https://github.com/forth-ev/VolksForth/tree/master/6502/C64)
[3.90](https://github.com/forth-ev/VolksForth/tree/c64-390/6502/C64).
Note that UltraForth was the earlier name of VolksForth's C64/C16 versions.

VolksForth C64/C16 3.90 has the fixes and enhancements (esp. UNLOOP) of my 3.82
as well as my simple INCLUDE implementation for loading .fth files integrated
into the core system. It also offers a lite version without the BLOCK mechanism
for loading d64 screen sources which cc64 doesn't use anymore.

Thus, cc64 is now built on stock VolksForth 3.90, which enabled the second
major change: porting to C16 (with 64k) and Plus4. As of v0.7, cc64 runs hosted
on C64 as well as on all C16 variants with 64k. Target runtime libraries
for both platforms are available on both hosts, enabling cross-compilation.

## v0.6

v0.6 was the first version built without any dependencies on d64 screen sources
anymore (see [Fourth sources](File-formats.md#forth-sources)), and also the
first version to live in the main directory.

v0.6 was the last not clearly defined version; it doesn't have git labels or
a github release. During its lifetime happened the development that lead to
v0.7.

## v0.5

v0.5 was the first open-sourced version and the last version that lived in its
own subdirectory. v0.5 marks the transition from
development on a real C64 with sources in UltraForth's screen format using
direct 1541 disk block access to emulator-based development with sources
in regular ASCII files. In v05 I also wrote a set of automated build scripts,
the first set of automated tests for both compiler and editor, and some simple
ascii-petscii conversion tooling to facilitate writing C64 sources on Linux.
Some bugs were also fixes along the way, esp. the known bugs from v04.

On the C64 I had used Dirk Zabel's excellent ASSI/M assembler for the runtime
library and a utility for patching the C64's charset. Moving to Linux I
switched to the
[ACME cross-assembler](https://sourceforge.net/p/acme-crossass/wiki/Home/).

v05 still contains the full sources in the UltraForth screen format on d64
disk images, which are also available in readable ASCII format.
See [Emulator and file formats -> Fourth sources](File-formats.md#forth-sources)
for details on the different file formats involved.


## v0.3 and v0.4

v.03 and v0.4 were the first two versions I published, without
Forth sources, as uploads to
ftp://ccnga.uwaterloo.ca/pub/cbm/INCOMING/programming,
on 6-Oct-1994 and 3-Nov-1995, respectively.
Thanks go to Craig Bruce at this point for keeping the archive on
<http://csbruce.com/cbm/ftp/c64/programming/>.

I keep v0.3 and v0.4 here mainly for the record. I don't recommend doing anything
with them.

