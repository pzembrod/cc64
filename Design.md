# Design

I'll try to at least start to give an overview of cc64's design.

## Overview

### Simplicity & scope limits

One principle I followed when writing cc64 was simplicity. I limited the scope
and took some shortcuts, just to have a chance of getting something
to run within my constraints of time and space. Constraints of time because
this was a hobby project while I was studying physics; I was a self-taught
programmer with no formal training about compilers. And constraints of space
because in the late 80s I was still programming on a C64 and had the ambition
to create a C compiler that fit into its memory and produced usable code.

One scope limitation is the [subset of C](C-lang-subset.md) aka Small C that
cc64 supports; for this I took both inspiration and justification from
Ron Cain and James E. Hendrix'
[Small C compiler](https://en.wikipedia.org/wiki/Small-C). The Dr. Dobbs book
was an excellent source for me.

Another scope limitation was motivated by the fact that there was no standard
linker or relocatable object code format available for the C64 at that time.
Also I knew of no available assembler that I could have easily bundled with
the compiler. Writing both myself on top of the compiler felt to be way too
much for me. So I decided that the compiler would generate executable binary
code directly from the parsed C source code. I figured that Turbo Pascal up to
version 3 did something similar.

### 1-pass source to binary

cc64 is a 1-pass compiler, going over the source code just once,
and producing binary (almost) executable code right away. The 6502 has
little support for relative addressing, so to use absolute addressing
the binary code's address or addresses must be known already at compile time.

cc64 achieves this in part by using a runtime module with known addresses
for start, end and runtime routine entry points. Compiled code is attached
to the end of the runtime module, so every statement and every function can
get its address right away. Jumps back into already generated code and calls
to already compiled functions can easily be generated because their target
address is already known. This is not so for forward jumps which occur both
calling functions that aren't yet defined and in control structures, e.g.
to jump behind the end of an `if` clause or a `while` loop.

To handle control structures I decided, even with constrained memory,
to keep the binary code for each function in memory while the function is
compiled. This of course limits the size of functions that cc64 can handle,
but it means that forward jumps in control structures can be generated with
0 as target address, and can be patched to the correct address once it becomes
known because the `jmp 0` statement is still in memory.

Calls to not-yet-compiled functions must be handled differently; for these
cc64 maintains a list of locations with forward calls, and these then get
patched during the minimalistic link step which joins the code of the
runtime module with the generated binary code into a single executable file.

Another prerequisite for generating runnable binary code directly from the
parser is this: the addresses of global and static variables need to be
allocated right when each variable is defined, so that any code that uses them
can be generated with the correct absolute address. To achieve this, cc64
allocates global and static variables from the end of the memory available for
variables, because the end of that memory is known before compilation starts,
whereas the start of the memory for variables is typically equal to the end
of the executable code, which of course is only know after compilation ends.

To initialize these addresses before compiling, cc64 provides the
[`#pragma cc64`](Runtime-libs.md#pragma-cc64) preprocessor command
which passes all the needed addresses plus the file name of the runtime module
to the compiler before the first function or variable is defined.
Usually the `#pragma cc64` line lives at the top of the header file that
comes with the runtime module, and the main program just needs to include the
runtime module header file and automatically gets the right address and file
name config for code generator and the mini-linker.

### A shortcut to libraries

Finally there's the challenge of libraries: how could things like `stdio.h`,
`ctype.h` or `string.h` and the associated library code be linked into an
executable when not much of a linker is available, and how could the
addresses of their library functions be known at compile time of the main
program so that calls to the functions can be generated with the correct
address during the single compile pass?

... work in progress ...



Code is generated - and kept in memory - one function at a time,
so that forward jumps in control structures can be resolved as soon
as the jump target becomes known. The only forward jumps that pass 1
cannot resolve are functions that are called before they are
defined. (That's why the generated code is only "almost"
executable.)

The generated code is not relocatable. The starting address is taken
from the chosen runtime module which has a defined start and end
address. The details about the runtime module, its interface used by
the compiled code, and how to write new runtime modules, is
described in [Code layout and library concept](Runtime-libs.md).

The nominal 2nd pass is just a minimal linker that concatenates
the chosen runtime module, the compiled binary code and the
initialization data for the static variables. The one processing
step done in pass 2 is the resolution of forward references of
functions.

... to be continued ...

### Main modules

The main and most interesting pieces of the compiler live in 2 groups
of 4 modules.

#### The symtab-scanner module group

The interface of the symtab-scanner module group consist of two services:

* Putting and finding local and global symbols
* Viewing and consuming the current input token

Both services are used by the parser-codegen module group.

##### symboltable.fth
This contains the global and the local symbol
table. Both symbol tables share the same memory block, with the
globals growing from the start upwards and the locals growing
from the end downwards. The globals additionally have a hash
table for faster access.

##### input.fth
reads source files line by line, calls the preprocessor, gives the scanner
a char-by-char view of the source, and transparently handles include files.

##### preprocess.fth
The cc64 preprocessor is very simple and a bit of a hack. It doesn't
process entire source files; instead it is called by input.fth for each
source line and handles the following preprocessor commands: ***(directives?)

* `#include` opens a new source file via input.fth.
* `#define` is especially hacky; it creates regular C constants in the
  global symbol table, i.e. it does *not* do any macro substitution.
* `#pragma cc64` selects and configures the [runtime module](Runtime-libs.md)
  to use; this is needed for generating executable binary code with
  absolute addresses right in the one compile pass.

##### scanner.fth
The scanner splits the source code into tokens - keywords,
identifies, numbers, operators and other characters. Its interface allows
the parser to view the current token without consuming it, and to move
to the next token.

#### The parser-codegen module group

This module group consists of 4 modules layered on top of each other, where
each module uses the service of the module underneath or, in the case of
parser.fth, of the two modules underneath. The interfaces between the modules
are extremely wide, representing entire instruction sets at increasing
levels of abstraction.

The interface of the overall module group, however, is very narrow.
It consists of the parser's main entry point `compile-program` and the
variable `main()-adr` which after the compile run contains the absolute
address of the compiled main function.

The 4 modules are

- 6502asm.fth which is only present during the compile time of the
  compiler and not part of the cc64 binary. It is needed to assemble
  the 6502 code templates of
- v-assembler.fth which is a template engine implementing something
  like a virtual CPU with a 16-bit accumulator through macros of
  6502 code. The VM inherits the 6502 hardware stack which is used
  for computing expressions via conventional stack postfix code.
  It also has a software stack via a stack frame "register", really
  a 6502 zero page pointer, which is used for local variables and
  function parameters.
- codegen.fth which contains most of the code generating logic.
  It uses the virtual 16-bit CPU and is structured almost in a
  1:1 relation to the parser.
  Many parser words have a corresponding codegen
  word that they call; in this way the (virtual) parse tree that
  the parser generates is immediately consumed again by the codegen
  so that the actual tree never materializes. codegen.fth also
  precalculates any constant expression or partial expression for
  which the value can already be determined at compile time.
- parser.fth which is a conventional recursive descent parser.
  It consists or 3 parts, expressions, statements and definitions,
  and mainly depends on scanner, symbol table and codegen.

The second module group's interface is really just the parser's
`compile-program`, and its output is binary code and static variable
initialization data written into two files, a list of forward
referenced function calls to patch, and the main function's address.

### Coupling within and between module groups

Esp. within the parser-codegen module group the coupling
between the individual modules is very tight, and the interfaces between
the modules are rather wide.

However, the interface that each module group exposes to its clients is very
narrow. This is of course nice from a general design point of view, but it
is also of very specific technical value: it allows cc64 to be compiled
in the limited main memory of the Commander X16. This is because while
compiling each module group, the many word headers for the wide intra-group
interfaces need to be kept in memory. But after each module group is loaded,
the inner interfaces aren't needed anymore, the word headers can be dropped,
and only the headers for the narrow inter-group interface needs to be kept
until cc64 is fully built. After that, also the inter-group interface
headers can be dropped as they aren't needed users run cc64 to compile their
C code.

Dropping word headers is of course VolksForth's heap with its transient
headers, and the mechanism for doing this in two stages, for intra-group and
for inter-group interfaces is the tempheap that was described in ***

