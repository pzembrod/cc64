# Usage

## Platform

cc64 versions exist for the C64, for C16 variants with 64k RAM, i.e.
a C16 or C116 with a 64k RAM expansion or a Plus4, and for the
new Commander X16.

## Downloads

[Releases](https://github.com/pzembrod/cc64/releases) consist of several
zip archives and disk and SDCard images. Most can also be downloaded
from head; they will often be a bit older than the latest sources at head,
though.

### cc64-*files.zip archives

These zip archives for all platforms (at head:
[cc64-c64files.zip](https://github.com/pzembrod/cc64/blob/master/cc64-c64files.zip),
[cc64-c16files.zip](https://github.com/pzembrod/cc64/blob/master/cc64-c16files.zip),
[cc64-x16files.zip](https://github.com/pzembrod/cc64/blob/master/cc64-x16files.zip))
are intended for unpacking into a directory mapped as a drive
(typically #8) of an emulator like [VICE](https://vice-emu.sourceforge.io/)
for C64 or C16, or for writing onto a disk of a real machine.

For use with the X16 emulator
[x16emu](https://www.commanderx16.com/forum/index.php?/files/file/25-commander-x16-emulator-winmaclinux/)
the content of cc64-x16files.zip must be copied into an SDCard image because
x16emu has only very limited support for mapping directories as drives
(LOAD and SAVE works, but no sequential files such as C source files).
A prepared SDCard image is also available (see below).
Writing onto a real SDCard for use in a real X16 works as well, of course.

### D64 disk images

The D64 disk images for C64 and C16 (at head: 
[c64files.d64](https://github.com/pzembrod/cc64/blob/master/c64files.d64) and
[c16files.d64](https://github.com/pzembrod/cc64/blob/master/c16files.d64))
can be attached to an emulator, of course, but should also be
usable for writing them onto a real 1541 or 1551 disk.

Note that the disk images contain the correct CBM file type (prg or seq) for
the C sources and runtime files.

### X16 SDCard image

A zipped prepared SDCard image (64 MB) for X16 (at head:
[x16files-sdcard.zip](https://github.com/pzembrod/cc64/blob/master/x16files-sdcard.zip))
can be attached to x16emu via the -sdcard flag.
It probably can also be written to a real SDCard, but for that purpose
the x16files.zip archive is probably better suited.

### recompile-cc64.zip

This zip archive (only available in
[Releases](https://github.com/pzembrod/cc64/releases))
is for recompiling the cc64 binaries from their Forth sources,
in setups where my Linux-based make and bash build doesn't work, e.g.
on a real C64, Plus4 or X16, or on a Windows-based emulator.

The archive works for all 3 platforms. Copy the archive content onto a disk,
a disk or card image or into a dir mapped to an emulator drive.
Load v4th-c64, v4th-c16+ or v4th-x16, depending on the platform,
run it, and then type

```
include cc64-main.fth
saveall cc64
```

to compile a new cc64 binary, or likewise for cc64pe and peddi. 
Note that peddi only runs on the C64 and C16, not on the X16.


## Binaries

There are 3 main binaries:

- `cc64` - the standalone compiler
- `peddi` - the standalone editor (only C64 and C16)
- `cc64pe` - compiler and editor combined (only C64 and C16)

peddi wasn't ported to the X16; instead, the X16 flavour of cc64 can
call Stefan Jakobsson's [X16Edit](Usage.md#x16edit)
editor if it is present in ROM.

## Shell

cc64 and peddi are written in Forth and use the Forth command line as shell.
The main consequence of this is that all numeric parameters to commands are
entered in RPN (reversed polish notation) - _before_ the command.

A heads-up: The German ancestry of the VolksForth means that some messages
are still in German. Namely the syntax error message says "Haeh?" which means
as much as "What?". No doubt we'll get more of VolksForth's messages
translated to English over time.

The full set of commands listed below is only available in the combined
compiler and editor binary `cc64pe`. The standalone compiler and editor
binaries only offer the corresponding subset of commands.

Numeric parameters, listed below as n, nnn or mmm, are 16 bit integers and
can be given either in decimal or, with a preceeding $, in hex.

## Commands

### Main commands

- `help`
  - shows a list of all commands
- `cc` _file.c_
  - compiles _file.c_, producing
    - a binary executable _file_ if _file.c_ contains a `main()` function
    - an extended runtime library consisting of _file.h_, _file.i_, _file.o_
otherwise
- `ed` _file_
  - opens _file_ in the text editor
- `cat` _file_
  - displays the content of _file_ on the screen
- `bye`
  - exits cc64

### Disk commands

- `dos`
  - reads and prints the error channel of the cc64's configured main disk drive
(see `device?` and `device` below)
- `dos` _xxx_
  - sends the command _xxx_ to cc64's configured main disk drive
- `dir`
  - lists the directory of cc64's configured main disk drive
- `device?`
  - shows the device number of the disk drive cc64 uses for source files and
compilation outputs, and the device number of the auxiliary disk drive where
cc64 places temporary files during compile. By default these are the same,
and there's only a reason to change that if space on the main drive becomes
an issue. Note: Currently the `dos` command only works on the main drive.
- _n_ `device`
  - configures cc64 to use device _n_ as main disk drive
- _n_ `auxdev`
  - configures cc64 to use device _n_ as auxiliary disk drive for temp files

### Memory commands

- `mem`
  - displays the compiler's memory setup
- _nnn_ `set-himem`
  - sets the upper limit of the compiler's memory to _nnn_. Default value is
$cbd0. The memory $cbd0-$cfff is needed by [c-charset](#c-charset) which cc64
recognizes and activates if it is installed. If a c-chargen rom generated by
[c-char-rom-gen](#c-char-rom-gen) is used, e.g. in an emulator, or if no C
charset (which provides the characters \^_{|}~) is desired, then himem can be
set to $d000.
- _nnn_ `set-heap`
  - sets the heap to _nnn_ elements. One heap element is needed for each forward
function reference, i.e. for each function that is called before it is defined.
A prototype, i.e. a declaraion, must exist before a function can be called.
- _nnn_ `set-hash`
  - sets the hash table size for global symbols. Needs at least one element per
compiled global symbol and should be sized reasonably generous for hasing to
be efficient. I'm sorry to say I don't have data yet, though.
- _nnn_ `set-symtab`
  - sets the symbol table size in bytes. This is used both for local and
global symbols and must be increased if a symbol table overflow error occurs.
- _nnn_ `set-code`
  - sets the size of the code buffer in bytes. The compiled code for each
individual compiled function must fit completely into this buffer. Otherwise,
a function too long error is thrown.
  - The remaining memory aka staticbuffer is used to buffer initialization values
of static variables. Its size isn't critical as it is flushed to file when full;
it just needs to be positive.
  - Not available on the X16 where a fixed code buffer of 8 kB lives in
banked RAM.
- _nnn_ _mmm_ `set-stacks`
  - sets the size of data stack (_nnn_ bytes) and return stack (_mmm_ bytes)
and resets the system. Note that the sizes shown by `mem` will be _nnn_ minus 6
and _mmm_ plus 6.  
The stack sizes determine the maximum depth of arithmetic expressions and the
maximum number of nested compound statements the compiler can handle. cc64 has
a recursive descend parser.  
Stack overflows are checked but I am not 100% sure how reliable these checks
are, and alas again I don't have any data to guide by yet.  
Should the compiler behave strangely on some deeply nested code, it should
be reloaded freshly from disk, and the stack sizes set to higher values.
- `saveall` _name_
  f- saves the complete compiler together with its actual memory settings to a
new file _name_

### Misc commands

- `1 list!`
- `0 list!`
  - switches listing the C source while compiling on respectively off. Default is off. Listing can cause ~25% increase in pass1 compile time.
- `list?`
  - shows whether listing is currently on or off.
- `exec` _file_
  - reads _file_ and executes the commands therein. This can be used e.g. to script compile operations.


## Peddi

Peddi is a small full screen, scrolling PETSCII editor for the C64 and C16.
There's no limit in line length (exept memory).
Memory overflow is signalled by a double flash of the screen border.
Peddi is called with

 `ed` _file_

Inside the editor, there are these key bindings:
```
cursor keys - as usual
return - split line
shift-return - goto begin of next line
del - del left of cursor or join lines
inst - insert a blank line
home - redraw screen
clr - kill line
F1 - 20 lines up
F7 - 20 lines down
ctrl-a - begin of line
ctrl-e - end of line
ctrl-d - del under cursor
ctrl-@ - del to cursor
ctrl-^ - del from cursor
ctrl-p - clear line
ctrl-w - save text
ctrl-x - exit and save text
ctrl-c - quit without saving
```

## X16Edit

For the X16 I recommend
[X16Edit](https://github.com/stefan-b-jakobsson/x16-edit) as editor.
If is present in ROM, it can be invoked with

 `xed filename`

to open an existing file, and with

 `xed`

to start editing with an empty buffer.

See its
[manual](https://github.com/stefan-b-jakobsson/x16-edit/blob/master/docs/manual.pdf)
for how to use it. See X16Edit's
[ROM Notes](https://github.com/stefan-b-jakobsson/x16-edit/blob/master/docs/romnotes.pdf)
for how to install it in ROM.

## Character set

C needs a few characters that the C64/C16/Plus4 charset doesn't contain:
 \^_{|}~  
cc64 comes with 2 options to fix this, a RAM and a ROM based. Both patch only
the lower/upper case charset, not the upper-case/graphic charset.

### c-charset C64

This is the RAM based option for the C64.

`c-charset` is a small assembler program starting at $cb3b. When loaded and
started, it will set up a patched charset in RAM from $d000 and move the
screen memory to $cc00. A small routine which can switch on again
the patched charset together with the moved screen memory lives from
$cbdf-$cfff and is detected and used by cc64 if present. That's why cc64's
default himem is $cbd0, not $d000.

Installation:

```
load "c-charset",8,1
sys 52026
```

Reactivation:

```
sys 52221
```

### c-charset C16

This is the RAM based option for the C16/Plus4.

`c-charset` is a small assembler program running from basic start.
It will set up a patched charset in RAM from $f000 and switch to this charset.
That's why cc64's default himem is $f000, not $fc00.
A small routine which can switch the patched charset on again lives from
$f800 and is detected and used by cc64 if present.

Installation:

```
load "c-charset",8
run
```

### c-charset X16

This is the RAM based option for the X16.

`c-charset` is a small assembler program starting at $0400. When activated,
it will generate a patched charset in RAM bank 6 from $a000-$a7ff and upload it to VERA.

Activation:

```
load "c-charset"
sys 1024
```

Note: For cc64 to use `c-charset`, it only needs to be loaded. cc64 will issue
the `jsr $0400` after startup if `c-charset` is loaded.

### patch-c-charset

This is the ROM based option. It is a C program in the tools/ directory and can
patch the needed C charsets into the character ROM images of C64, C16 and X16 -
and probably of other CBM machines with the same 8x8 charset, too.
The patched ROM image can then be used with an emulator, or programmed into
an (E)EPROM.

`patch-c-charset` takes an input and an output ROM image file name and
one or two options -n and -i that specify at which offset in the image
the normal (-n) and/or the inverse (-i) lower/upper case charset starts.
These are the invocations that work for C64, C16 and X16:

#### C64:

The ROM image that needs to be patched is the chargen ROM, length 4k.
The first 2k contain the upper/graphics charset, the second the lower/upper,
first normal followed by inverse:

```
patch-c-charset -n 2048 -i 3072 chargen-orig chargen-patched
```

#### C16:

Here the charset is part of the 16k KERNAL ROM ($c00-$fff). The charset
starts at $d000, so 4k into the ROM image. Different from the C64, the C16
has and needs no inverse charset; inverse characters are generated by the
TED chip on the fly via a video attribute, or so I understand. Anyway, only
the normal charset needs to be patched; the lower/upper case charset starts
at $d400, so 5k into the image:

```
patch-c-charset -n 5120 kernal-orig kernal-patched
```

#### X16:

Here the charset lives at the start of ROM bank 6, part of the main system ROM,
called rom.bin in the x16emu distribution.
Each ROM bank is 16k, so the charset starts 96k into the ROM image.
Somewhat similar to the C16, the X16 has no inverse charset in ROM.
The VERA chip needs an inverse charset, so it must be generated by the KERNAL
code while uploading the ROM charset to VERA. Note: The X16 c-charset RAM
util generates the inverse charset, too, and patches it, before uploading it
via KERNAL call to VERA.
Anyway, when patching the ROM, only the normal charset needs to be patched;
the lower/upper case charset starts right after the 1k-long upper/graphics
charset, so it is 97k into the image:

```
patch-c-charset -n 99328 rom-orig.bin rom-patched.bin
```

You'll find these calls in the main Makefile, with the ROM image paths as
setup in my dev machine.

### c-char-rom-gen

This is the old C64-only ROM based option, now superseeded by
`patch-c-charset`.

`c-char-rom-gen` is an assembler program running from basic start which, when
run, will the ROM charset into RAM (at $c000), patch the needed characters,
and then save the RAM $c000-$cfff to disk in a file named `c-chargen` which
then can be used by an emulator as chargen or programmed into an (E)EPROM and
used in a real C64.

## Keyboard

There are two custom keyboard maps for VICE available in the
[emulator/](https://github.com/pzembrod/cc64/tree/master/emulator) directory that I use under Linux to map the C characters \^_{|}~ symbolically to the respective keys on the host keymap, one for the
[C64](https://github.com/pzembrod/cc64/blob/master/emulator/x11_sym_c64_vf_de.vkm) and one for the [C16](https://github.com/pzembrod/cc64/blob/master/emulator/x11_sym_c16_vf_de.vkm). The options I use are visible [here](https://github.com/pzembrod/cc64/blob/master/emulator/which-vice.sh), and I should add the disclaimer that I use German keyboard layouts, though I believe this should not matter since the key mapping used is symbolic, not positional.

For x16emu I currently actually don't know how to type those keys in PETSCII mode. The right thing to do is likely anyway to compile an ISO version of cc64 - which is on my road map.
