# cc64

cc64 is a small-C compiler written in Forth, targeting the 6502 CPU and
hosted on the C64. I wrote it during my university years; the
majority of the code was written 1989-1991.

Motivated by puzzphp's project to build a C library for cc64
(https://sourceforge.net/projects/cc64/) and by Johan Kotlinski of
DurexForth (https://github.com/jkotlinski/durexforth), I am now finally
open-sourcing the project.

## v03 and v04

v03 and v04 were the first two versions I published, without
Forth soruces, as uploads to a public ftp server
(ftp.funet.fi to /pub/cbm/c64/programming IIRC),
on 6-Oct-1994 and 3-Nov-1995, respectively (thanks go to Craig Bruce
for keeping the archive on http://csbruce.com/cbm/ftp/c64/programming/).

I keep them here mainly for reference. I don't recommend doing anything
with the files in there.

## v05

This is the first open-sourced version, and the one I intend to maintain
for the near future. The main purpose of this version is to consolidate
development after moving from real C64 to emulator and Linux.
This involved switching from Dirk Zabel's excellent assembler ASSI/M
I had been using on the C64 to the 
[ACME cross-assembler](https://sourceforge.net/p/acme-crossass/wiki/Home/),
and some simple ascii-petscii conversion tooling to facilitate writing
C64 sources on Linux.

Forth sources are still kept in the ultraFORTH screen format on d64
disk images, though they are also available in ASCII file form, but that
is for the time being only for the purpose of reading by humans.
It is planned as a next major step to build from file-based
Forth sources and deprecate the Forth screen d64 disk images.
