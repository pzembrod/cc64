# cc64 versions

## v0.13.1

v0.13.1 contains no code changes. The only change is around the .d64 distribution files in the release:

For the Commander X16, there's a new d64 image `cc64-x16files.d64` for
Commander X16 setups with 1541 drive(s).
And to the `cc64-c64files.d64` and `cc64-c16files.d64` images, a few newer sample files were added that had not been included in these images before.

## v0.13

v0.13 updates the VolksForth build base from 3.9.5 to 3.9.6 which
slightly reduces the size for the Commander X16 version of cc64 and also
should make it much more robust against new Commander X16 ROM releases.
A visible consequence of this change is that cc64's command line now uses
the regular Commodore screen editor.

For the records: v0.13 was tested with ROM R47. v0.12 works with R47, too.

The Commander X16 version of [`c-charset`](Usage.md#c-charset-x16) is now
working correctly; in v0.11 I had forgotten to adapt it to use the changed
bank switching address of prototype #2 and subsequent boards. Thanks to leop
for pointing this out to me.

Minor changes: Scratching of temp and output files before, during and after
each compile run was fixed and refactored. The [`src/samples/`](src/samples)
dir contains some code I wrote inspired by the
[Vintage Computing Christmas Challenge 2023](https://logiker.com/Vintage-Computing-Christmas-Challenge-2023).
And the [`run-in-x16emu.sh`](emulator/run-in-x16emu.sh) script doesn't use
the generated SDCard image anymore but runs directly off the `x16files/` dir
using x16emu's `-fsroot` option.

## v0.12

v0.12 updates the VolksForth build base from 3.9.4 to 3.9.5 which
migrates the Commander X16 version of cc64 to the Kernal version R46.
For C64 and C16 the change should be a no-op.

## v0.11

v0.11 updates the VolksForth build base from 3.9.3 to 3.9.4 which
migrates the Commander X16 version of cc64 to the Kernal version R41
and the new prototype #2 board. For C64 and C16 the change should
be a no-op.

## v0.10

The three main changes that v0.10 brings are ANSI syntax for
function definitions, a basic libc, and proper support
for `_fastcall` functions, with a related breaking change
in runtime module .h file format.

ANSI style function definitions (```char f(int a) {...}```) are
implemented as a syntactic alternative to K&R style function
definitions (```char f(a) int a; {...}```) with exactly the same
semantics, i.e. there is no matching or checking of declared
parameter types and actual parameter types in function calls.

The new basic libc, incl. tests, is based on
[PDCLib](https://pdclib.rootdirectory.de/) (thanks go to Martin
"Solar" Baute and to Erin Shepherd). Of course,
only a limited range of standard libc functions make sense on an
int/char only compiler on the C64, C16 or X16. E.g. wchar, float,
time, locale or signal related functions were left out completely.
In the end, 18 ```string.h``` functions and
2 ```stdlib.h``` functions were ported from PDCLib,
and 2 functions from ```stdlib.h```, 8 functions
from ```ctype.h``` and 12 functions from ```stdio.h``` were
reimplemented in 6502 assembly, while often porting the PDCLib
tests. The cc64 libc is available in precompiled runtime modules
`libc-*.[hio]`, to be used instead of `rt-*.[hio]`.

cc64 always could call a type of assembly-implemented single-param
functions which need no own stack frame and get the param passed in
a/x. However, this type wasn't properly named, and such functions
could be defined by stating their address, but not declared,
nor could they be called through pointers. Initial purpose of these
functions was to interact with the Kernal.

Now many libc functions are implemented as this function type,
named "fastcall" going forward. To allow the libc header files
ctype.h, stdio.h and stdlib.h to declare these functions,
v0.10 introduces a **BREAKING CHANGE** with regard to the format of
the `rt-*.h` and `libc-*.h` files:

Previously, \*= defined a function to be fastcall, and set its
address,
and /= set the address of regular C library functions and variables.
Now, \*= sets the addresses of all library functions and variables,
and fastcall functions are additionally marked with the new keyword `_fastcall`.

- fastcall functions:
  - until v0.9:
     - `extern char _chrin() *= 0xFFD2;`
  - from v0.10:
     - `extern _fastcall char _chrin() *= 0xFFD2;`
- regular functions and variables:
  - until v0.9:
     - `extern int fopen() /= 0xB7E;`
     - `extern char errno /= 0x9FDB;`
  - from v0.10:
     - `extern int fopen() *= 0xB7E;`
     - `extern char errno *= 0x9FDB;`

Reasons for making this a breaking change:
I was always somewhat unhappy with /= for regular functions, as
I found \*= (sets the starting address with many assemblers)
to be very expressive, and /= to be very unimpressive, so I was
happy to retire it quickly. Also, a breaking change saved compiler
code size (which is tight), and I figured there shouldn't be much
usage of \*= and /= out there yet.

The new keyword `_fastcall` allows declaring fastcall function
pointers. Implementing them required the addition of two new calls
to the runtime library interface jumplist.

Fastcall function can now only be called with the one parameter that
the function can actually receive. Previously, additional parameters
were silently dropped, which a) I now consider wrong, and b) was a
waste of scarce compiler code size. On that note, I shortened a few
compiler error messages to fit the new feature into the X16.

The naming scheme for the basic runtime libraries `rt-*.[hio]` now
includes both start and end address, to facilitate different
versions, e.g. using or not using the RAM under the BASIC ROM
on the C64.

Finally, there are now more parser unit tests, some compiler bugs
discovered while implementing the libc were fixed,
and binary sizes are now tracked in
[bin-size-register](bin-size-register).

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

