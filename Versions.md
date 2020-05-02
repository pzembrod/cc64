# cc64 versions


## v05

This is the first open-sourced version, and the one I intend to maintain
for the near future. The main purpose of this version is to consolidate
development after moving from real C64 to emulator and Linux.
This involved switching from Dirk Zabel's excellent assembler ASSI/M
I had been using on the C64 to the
[ACME cross-assembler](https://sourceforge.net/p/acme-crossass/wiki/Home/),
and some simple ascii-petscii conversion tooling to facilitate writing
C64 sources on Linux. It also involved getting the build automated and adding
a first suite of smoke tests. This has progressed enough by now that I feel
I can start to iterate on the compiler itself without too much fear of breaking
something.

Most of the Forth sources are still kept in the ultraFORTH screen format on d64
disk images, though they are also available in ASCII file form for reading by
humans. Going forward I plan to slowly migrate the sources from which cc64 is
built to ASCII Forth source files. This should also facilitate unit testing
of the compiler itself, and bug fixes.

The goal is to eventually deprecate the
ultraFORTH screen d64 disk images, and to build cc64 on top of a Forth core
without the code for reading screen sources, as that would save quite a bit of
size for the cc64 binary (which is built on top of the ultraFORTH core).
See [Emulator and file formats](File-formats.md) for details on the different
file formats involved.

Another goal is to eventually build cc64 e.g. on GForth to produce a cross
compiler hosted on Linux.

Bug fixes in v05:

* Linking static variables works correctly now.
[fix](https://github.com/pzembrod/cc64/commit/92d96c83061e98274cbd2bdd284ab6e8e6d5c0c0#diff-09a338ea0cdb8481c5925164ea4253bf)
* Assembler functions declared with *= can now be called even without
passing a parameter.
[fix](https://github.com/pzembrod/cc64/commit/f784de39d5751b58dc122b7bb789c3a14d08b017#diff-09a338ea0cdb8481c5925164ea4253bf)

Known bugs in v05:

* Compiling functions after they have previously been declared as extern
(needed for calling functions before they are defined) ist broken.
[issue 5](https://github.com/pzembrod/cc64/issues/5)


## v03 and v04

v03 and v04 were the first two versions I published, without
Forth soruces, as uploads to a public ftp server
(ftp.funet.fi, IIRC, into /pub/cbm/c64/programming),
on 6-Oct-1994 and 3-Nov-1995, respectively.
Thanks go to Craig Bruce at this point for keeping the archive on
<http://csbruce.com/cbm/ftp/c64/programming/>.

I keep v03 and v04 here mainly for the record. I don't recommend doing anything
with them.

