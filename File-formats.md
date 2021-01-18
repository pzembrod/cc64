# Emulator and file formats

Originally I developed cc64 on a real C64, with a 1541 disk drive. The move to
development on an emulator brought a number of advantages, namely faster builds
and larger disks. It also came with a number of challenges around disk drive
emulation, Commodore's non-ASCII character set (known as PETSCII), the
keyboard differences between PCs and C64, and the fact that UltraForth sources
aren't even files.

This page describes cc64's integration via emulator into its hosting Linux.
I apologize for the length of this page. It does cover the yield of
several weekends' work, though.

## VICE emulator

I'm using the
[Versatile Commodore Emulator VICE](https://vice-emu.sourceforge.io/) for building
and running the C64 and C16 versions of cc64. It has good interfacing with the host OS for my purposes, and in general is working really well for me. I esp. love its warp mode which, on my machine, gives me >100x the speed of a real C64. It's nice if a build takes less than 10 sec instead of 15 min.

Initially I used Ubuntu's default version. But after Ubuntu 20.04 packaged the more accurately emulating (which I don't need) but slower (which hurts me) x64sc instead of the old x64, I switched to building my VICE binaries from source.

Note: VICE doesn't come with the
[C64 ROMs](https://vice-emu.sourceforge.io/vice_4.html#SEC26)
needed to run a C64 on it; these must be obtained elsewhere.

### Disk drive options

VICE offers a number of different
[disk drives it can emulate](https://vice-emu.sourceforge.io/vice_2.html#SEC15),
and two ways how it can emulate them. I am using the virtual drive option
which is very fast, and though it only supports drive access through the
regular Kernal routines, this is fine because neither UltraForth nor cc64 do
anything else.

I did try the true drive emulation option, but it's very slow; using it with
a SpeedDos floppy speeder (VICE can simulate parallel cables!) gave me problems,
and true drive emulation also doesn't allow backing an emulated drive with a
Linux host directory - a very useful feature.

I'm using a virtual 1541 drive backed by a Linux file system directory as
drive 8 in all VICE configs for cc64. In those configs that need to handle
Forth source screens (which live directly in 1541 disk blocks on D64 disk
images (see [below](#UltraForth-screens-on-a-1541)), I have 3 additional
1541s configured as drives 9, 10 and 11, backed by the disk images
cc64src1.d64, cc64src2.d64 and peddi_src.d64.

This is luxury, curtesy of the emulator: never having to change Forth source
disks during build again, plus a drive 8 with virtually unlimited disk space.

### ASCII and PETSCII files

I wanted to edit files, esp. C sources, for cc64 on Linux, which then had to be
converted from ASCII to PETSCII. I couldn't find an existing converter that
suited my needs, so I wrote two small tools, ascii2petscii and petscii2ascii,
for this purpose.

A subsequent problem was not to confuse the ASCII and PETSCII versions of the
same files.

### P00 files vs. plain files in a subdir

One common emulator file format are the so-called P00 files. It is used in
host-dir-backed virtual drives and contains, in a header, the file's name as
seen from the emulator. The files' extension also marks the CBM file type:
P00/01/02/... are prg files, S00/01/02/... are seq files etc.

To keep ASCII and PETSCII C files apart, I tried this format: file.c would
be ASCII and file.c.S00 would be the same in PETSCII. Again I wrote two small
tools for this conversion: bin2p00 converts a binary file, e.g. a C64
executable, into a P00 file, and txt2s00 converts an ASCII file, e.g. a
C source, into a PETSCII S00 file.

VICE can be configured to only show P00/S00 files from a directory to the
emulated drive, and also to save files in P00/S00 format, too. This allowed
for a clean separation of C64 and Linux files. Alas, it turned out that VICE
doesn't handle renaming P00 files properly, and since Peddi maintains a backup
version of the edited text file when saving, and uses file renaming for that,
I decided that the rename issue was a show stopper for using P00 files.

Instead I am now using a c64files/ respectively c16files/ subdirectory as
backing dir for drive 8 in most VICE configs and so keep PETSCII and ASCII
files separate: PETSCII files live in c64files/ or c16files/, and ASCII files
live in the main directory. Makefiles handle the conversion as needed.

### Running on a real C64

As a corrolary, the contents of the c64files dir is all that should be
needed to run cc64 on a real C64. They are available either as c64files.zip
file or as c64files.d64 1541 disk image.

### Autostarting T64 images in VICE

For scripted building of cc64 from source, and scripted running of tests,
I needed a way to start programs inside VICE from the command line. VICE does
have an autostart option which can take a C64 program. It does so by creating
and on-the-fly disk image containing just the autostarted program which is then
loaded an run. Unfortunately this overrides any other drive config, so for my
use case where I need up to 4 drives to build cc64, this didn't work.

Fortunately, VICEs -autostart can also take T64 tape images. Then the first
program from that tape image is loaded and run, and the disk drive config is
left alone. This was what I needed, so I wrote yet another small tool, bin2t64,
that turns a C64 program into a tape image.

### Scripted workflows with VICE

Autostarting UltraForth or cc64 inside VICE got me only half the way to a
scripted build; the compile invocation still needed to be entered. Fortunately,
VICE can fill the C64 keyboard buffer using the -keybuf option. Remarkably,
this option can take more than 10 characters, the C64's keyboard buffer length.

The final missing bit, stopping VICE again after a finished build or test run,
is accomplished with a trick: The VICE wrapper scripts place a file named
"notdone" into drive 8's directory and kill VICE when that file disappears.
So the build and test scripts inside VICE can signal they're done by
scratching the file "notdone".


## x16emu

For building and testing the [Commander X16](https://www.commanderx16.com/)
flavour of cc64 I am using the official emulator [x16emu](https://www.commanderx16.com/forum/index.php?/files/file/25-commander-x16-emulator-winmaclinux/).
Other than VICE, x16emu supports only very limited file operations from a
Linux-dir backed emulated drive, namely just LOAD and SAVE, but no sequential
file operations which cc64 of course needs. x16emu supports full file
operations only with an SDCard image backed drive. I am nonetheless using an
x16files/ dir containing PETSCII files in the same way as c64files/ and
c16files/ with VICE, and in a separate step the content of this dir is written
into an SDCard image to be then used by x16emu. After a build or test run,
expected output files are then copied from the SDCard image back to x16files/.

Autostarting and cripting x16emu works very similar to scripting VICE, with the
difference that the T64 mechanism doesn't work. Instead, the binary is put into
x16files/ and thus the SDCard image, and the keyboard buffer input, which in
this case also includes a LOAD and a RUN command, needs to be passed to x16emu
in a file instead of a command line flag.

Signalling the completion of a build or test operation by scratching the
"notdone" file works just like in VICE, with the difference that the script
controlling and eventually terminating x16emu needs to look into an SDCard
image instead of into a directory.

For formatting and copying to and from SDCard images I use the tools from the
Debian package "mtools" (they do need root privilege like loopback mounting
would), and for initial partitioning I use sfdisk from the "fdisk" package.

## Forth sources

### Forth source screens

UltraForth stores its sources in the classical Forth style, in so called
screens. A screen is a 1k block of source, often directly stored on 1, 2, 4
or 8 disk blocks, depending on the disk sector size, and just addressed by a
block number. In this way you can handle source code on a bare-metal system
(a common use case of Forth) without any need for a file system. The screen
is usually treated as 16 lines of source, with 64 characters each. No newline.
Because the C64 display has only 40 characters per line, UltraForth tweaks that
a bit and treats a screen as 24 lines of 41 characters and 1 line of 40.
Still no newlines.

### UltraForth screens on a 1541

UltraForth stores 169 screens of source per 1541 disk, bypassing the file
system, using block-read and block-write commands. The directory of such a disk
is empty; all blocks are marked as allocated in the disk's BAM
(Block Allocation Map). The cc64 sources lived on 2 disks (I outgrew the first
disk when I moved to develop code generator and parser), and now, after
migrating to development on an emulator, on two D64 disk images,
cc64src1.d64 and cc64src2.d64 in the v05/src directory. A third disk image
contains the sources of the text editor Peddi.

Now, looking at UltraForth screens in a D64 image from a modern machine,
e.g. Linux, has two snags: One, the sources are in PETSCII, not ASCII. And two,
they seem to consist of just one giant line. At best 2, in case the BAM and
directory in the middle (track 18 sectors 0 and 1) of the disk happen to
contain a newline. So, not very useful. Also not good for tracking diffs in
git.

### Workaround for reading Forth screens

As a workaround I wrote a small tool, ufscr2file, that converts the PETSCII
screens of a D64 image into an ASCII file, with inserted comments between the
screens containing the screen or block number. The files produced are
cc64src1.fth and cc64src2.fth, also in the v05/src directory. They are not the
source of truth but are kept up to date, and arethe place to go to for
reading the Forth screen sources of cc64. One caveat: The sources are not
compiled from start to end; compilation is rather guided by so called
load screens; on all 3 disks that is screen/block number 4, which then loads
all other needed screens from that disk. So the "Block No." comments in those
.fth files are crucial for understanding how the different parts of the source
are connected.

### Downsides of source screens

I have felt the contraints of the screen format a lot while developing
cc64, mainly because some module grew larger than the number of screens I had
initially allocated for it, and bumped into the next module, and also because
I had to insert code in the middle of a module and shift half of the module's
screens a block back. There are still traces to be found in cc64's sources
where I have moved modules from one part of a disk to another because I ran
out of space somewhere.

### Regular Forth source files

Since the advent of ANS Forth in 1994, regular text files have been standardized
as the preferred form of Forth sources, and they seem to be the more common
from now. UltraForth 3.82 isn't ANS compliant, but I hacked together a
simplified version of the ANS word INCLUDE; it lived in cc64src1.d64/fth blocks 132-135 in v05/src. Initially using this only for top-level build scripts,
basically replacements for top-level load screens, I have, in the step from
v05 to v06, moved all of cc64's sources into text files from which it is now
built. And as of v07, the INCLUDE implementation now comes from the core
VolksForth 3.90 to which it has been ported. See [Versions](Versions.md)
for details.
