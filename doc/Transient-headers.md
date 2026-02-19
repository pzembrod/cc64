# Transient Headers & Code

This page describes the mechanism and use of transient word
headers and transient code,
i.e. word headers and code that are present while cc64 itself is compiled
but aren't part of the final cc64 binary.

## Transient headers

cc64 makes extensive use of VolksForth's feature of transient word headers.
VolksForth has a special temp memory area called the heap. It's outside the
dictionary and has little to do with the heap of languages like C or Java.
When words are compiled, their VolksForth can place their header onto the
heap instead of into the dictionary. The heap can later be cleared, which
removes all word headers on the heap but leaves the compiled code, hence
transient headers.

Almost all words in cc64 have transient headers; the only exception are
the words that make up the user interface, i.e. words by which the user
invokes the compiler. The overall size of cc64's transient headers is over
14 kB which thus aren't part of the final compiler binary. That's significant
given a binary size of 32 kB, consisting of 14 kB VolksForth base system and
18 kB cc64 code.

## Transient code

What is true for most word headers - that they are needed only while cc64 is
built, not when it is run - is also true for some code, namely for the
VolksForth's 6502 assembler which is needed to assemble the 6502 code
templates of cc64's lowest code generator level
(see [v-assembler.fth](Sources-overview.md#v-assemblerfth)), and also for
a small number of words that are written as code words either for
performance reasons or to invoke X16Edit which is written is assembly and
lives in a ROM bank.

VolksForth already comes with a version of its 6502 assembler that is
loaded not into the regular dictionary, but into the heap.
The way this is achieved is deceptively simple: The dictionary pointer
is saved, space is allocated on the heap, the dictionary pointer is
set to the allocated heap space, transient code is loaded, and
then the dictionary pointer is restored:
```
here   $800 hallot  heap dp !
include 6502asm.fth
dp !
```
Until the heap is cleared, the loaded code, in this example the assembler,
is available like regular code and can be used to e.g. create code words.
When the heap is cleared, both the headers and their code are removed,
without a remaining trace.

## Interfaces, coupling, and source groups

Most source files intend to be a module with a well-define interface.
Often this interface is explicitly listed at the top of the file.

Two sources, however, namely v-assembler.fth and codegen.fth,
have interfaces so wide that it wouldn't make sense to list them.
Together with parser.fth they form a tightly coupled group of sources where
codegen's interface is just used by parser and v-assembler's interface is
used by codegen and parser. The interface that parser.fth exposes to the
compiler's top level is again very small, so that the three sources togehter
can be seen as one module or source group with a small interface.

The interface size has technical significance because esp. on the
Commander X16 the main, non-banked memory is so limited that there isn't
enough space for all the 14 kB of transient headers while the compiler is
built. The solution for this came when I realized that not all 14 kB are
needed in memory at the same time, and that the pattern of keeping the
headers of cc64's user interface words while discarding the headers of words
actually implement cc64 can be repeated on a smaller scale: keep the
headers of module interface words in memory until building all of cc64
is done, and discard the headers of implementation words of a module as soon
as that module is built.

## tmpheap

Thus the idea of a two-staged heap called tmpheap was born. The reuse of
heap memory for implementation word headers relieved the memory pressure, but
only by a surprisingly small amount of about 1.8 kB - which wouldn't have
been enough to fir the build process into the X16 main memory.

The reason for this unexpectedly small win turned out to be the large size of
the v-assembler/codegen/parser source group, which together use 6 kB of tmpheap
space for implementation word headers. Add to this 2 kB for the transient
6502 assembler, needed to build v-assembler and therefore also placed on the
tmpheap, yields a required tmpheap size of almost 8 kB. And most of those
8 kB aren't reused by the other source files, most of which only need around
or even below 100-200 bytes for implementation word headers.

However, the introduction of the
tmpheap enabled something else on the X16: The tmpheap can be placed into one
bank of the X16's banked memory and thus win an additional 8 kB while
building cc64, and that made the difference between buildable and
dictionary overflow.

## Related sources

### tmpheap.fth and x16tmpheap.fth

These two files contain the implementation of the tmpheap mentioned above.
tmpheap.fth is the default implementation that places the tmpheap onto
VolksForth's regular heap. x16tmpheap.fth places the tmpheap into the
Commander X16's banked RAM.

Thanks to the design of the heap of VolksForth it
could be implemented in just 50 lines, though it did need one small
incompatible change in the VolksForth kernel, though I think that barely
anyone was really affected by the incompatibility.

tmpheap is described in
[Vierte Dimension 3/2021](https://forth-ev.de/wiki/projects:4dinhalt#heft_4d2021-03).

### trnstmpheap.fth and x16trnstmphp.fth

The tmpheap mechanism is only needed during the building process of cc64.
This means that even the code that creates and manages the tmpheap can
be transient, i.e. put onto the regular heap, and be cleared out before
the cc64 binary is written to disk. That is what trnstmpheap.fth and
x16trnstmphp.fth do.

### trns6502asm.fth and tmp6502asm.fth

This is the transient Forth 6502 assembler of VolksForth, loaded onto the
heap (trns6502asm.fth) or, in the case of C64 or X16, onto the tmpheap
(tmp6502asm.fth). It is only present
while the cc64 compiler itself is compiled; it is not part of the cc64 binary.

It is used to assemble the 6502 code templates of
`[v-assembler.fth](Sources-overview.md#v-assemblerfth)` as well as several
code words in `lowlevel.fth`, `strings.fth` and `x16edit.fth`.

When the assembler is loaded onto the tmpheap, the
facts that the tmpheap gets cleared several times after groups of source
files are loaded, and that the files with low level code words live in
a different source group than v-assembler, have the consequence
that tmp6502asm.fth must be loaded twice during the overall compile run,
once for each source group that needs it.
