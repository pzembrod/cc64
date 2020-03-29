# cc64 versions


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
As a next major step I plan to build from file-based
Forth sources and deprecate the Forth screen d64 disk images.


## v03 and v04

v03 and v04 were the first two versions I published, without
Forth soruces, as uploads to a public ftp server
(ftp.funet.fi, IIRC, into /pub/cbm/c64/programming),
on 6-Oct-1994 and 3-Nov-1995, respectively.
Thanks go to Craig Bruce at this point for keeping the archive on
<http://csbruce.com/cbm/ftp/c64/programming/>.

I keep v03 and v04 here mainly for reference. I don't recommend doing anything
with the files in there.

