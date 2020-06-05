# cc64 versions

## current

The main directory structure contains the current version of cc64 which is
under active development and recommended for use.

The older versions v03, v04 and v05 are living in the respective subdirs.


## v05

v05 was the first open-sourced version and marks the transition from
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
See [Emulator and file formats](File-formats.md) for details on the different
file formats involved.


## v03 and v04

v03 and v04 were the first two versions I published, without
Forth sources, as uploads to
ftp://ccnga.uwaterloo.ca/pub/cbm/INCOMING/programming,
on 6-Oct-1994 and 3-Nov-1995, respectively.
Thanks go to Craig Bruce at this point for keeping the archive on
<http://csbruce.com/cbm/ftp/c64/programming/>.

I keep v03 and v04 here mainly for the record. I don't recommend doing anything
with them.

