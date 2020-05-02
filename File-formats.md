# Emulator and file formats

Originally I developed cc64 on a real C64, with a 1541 disk drive. The move to
development on an emulator brought a number of advantages, namely faster builds
and larger disks. It also came with a number of challenges around disk drive
emulation, Commodore's non-ASCII character set (known as PETSCII), the
keyboard differences between PCs and C64, and the fact that ultraFORTH sources
aren't even files.

This page describes cc64's integration via emulator into its hosting Linux.

## Vice emulator

I'm using the
[Versatile Commodore Emulator VICE](https://vice-emu.sourceforge.io/).
It seems to be the most mature and best maintained platform-independent C64
emulator these days, it's available via Debian's and Ubuntu's package
repository, has good enough interfacing with the host OS for my purposes,
and in general is working really well for me. It can emulate other
CBM machines, too, and even the SuperCPU module - which I tried out, but found
that I didn't need it, thanks to VICE's warp mode which, on my machine, gives
me ~60x the speed of a real C64.
It's nice if a build takes 15 sec instead of 15 min.

Note: VICE doesn't come with the
[C64 ROMs](https://vice-emu.sourceforge.io/vice_4.html#SEC26)
needed to run a C64 on it; these must be obtained elsewhere.

### Disk drive options

VICE offers a number of different
[disk drives it can emulate](https://vice-emu.sourceforge.io/vice_2.html#SEC15),
and two ways how it can emulate them. I am using the virtual drive option
which is very fast, and though it only supports drive access through the
regular Kernal routines, this is fine because neither ultraFORTH nor cc64 do
anything else.

I did try the true drive emulation option, but it's very slow; using it with
a SpeedDos floppy speeder (VICE can simulate parallel cables!) gave me problems,
and true drive emulation also doesn't allow backing an emulated drive with a
Linux host directory - a very useful feature.

I'm using a virtual 1541 drive backed by a Linux file system directory as
drive 8 in all VICE configs for cc64. In those configs that need to handle
Forth source screens (which live directly in 1541 disk blocks on D64 disk
images (see [below](#UltraFORTH-screens-on-a-1541)), I have 3 additional
1541s configured as drives 9, 10 and 11, backed by the disk images
cc64src1.d64, cc64src2.d64 and peddi_src.d64.

This is luxury, curtesy of the emulator: never having to change Forth source
disks during build again, plus a drive 8 with virtually unlimited disk space.

### ASCII and PETSCII files

### P00 files vs. plain files in a subdir

One common emulator file format are the so-called P00 files.

## Forth sources

### Forth source screens

UltraFORTH stores its sources in the classical Forth style, in so called
screens. A screen is a 1k block of source, often directly stored on 1, 2, 4
or 8 disk blocks, depending on the disk sector size, and just addressed by a
block number. In this way you can handle source code on a bare-metal system
(a common use case of Forth) without any need for a file system. The screen
is usually treated as 16 lines of source, with 64 characters each. No newline.
Because the C64 display has only 40 characters per line, ultraFORTH tweaks that
a bit and treats a screen as 24 lines of 41 characters and 1 line of 40.
Still no newlines.

### UltraFORTH screens on a 1541

UltraFORTH stores 169 screens of source per 1541 disk, bypassing the file
system, using block-read and block-write commands. The directory of such a disk
is empty; all blocks are marked as allocated in the disk's BAM
(Block Allocation Map). The cc64 sources lived on 2 disks (I outgrew the first
disk when I moved to develop code generator and parser), and now, after
migrating to development on an emulator, on two D64 disk images,
cc64src1.d64 and cc64src2.d64 in the v05/src directory. A third disk image
contains the sources of the text editor Peddi.

Now, looking at ultraFORTH screens in a D64 image from a modern machine,
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
as an alternative form of Forth sources, and they seem to be the more common
from now. UltraFORTH  isn't ANS compliant (yet) and doesn't support text
source files, but I hacked together a simplified version of the ANS word
include; it lives in cc64src1.d64/fth blocks 132-135. I'm so far only using
this for top-level build scripts, basically replacements for top-level load
screens, but my plan, going forward, is to move more and more of cc64's source
into text files and build from there.
