# Goals & Ideas

This page aims to give an overview of the design goals and basic ideas of cc64.

## Simplicity & scope limits

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
code directly from the parsed C source code. I took inspiration for this
approach from Turbo Pascal up to version 3 which seemed to do something
similar. This way I only need a mini linker that joins the code of a runtime
library with the generated binary code into a single executable file.

Finally I decided to make the preprocessor very simple and only support
`#define` statements for simple constants, and `#include`, nothing else.
Out of necessity I later added one `#pragma` command, but that was it.

## 1-pass source to binary

cc64 is a 1-pass compiler, going over the source code just once,
and producing binary (almost) executable code right away. The 6502 has
little support for relative addressing, so to generate code with absolute
addressing the code's target address must be known already at compile time.
cc64 achieves this by using a runtime module with known addresses
for start, end and runtime routine entry points. Compiled code is attached
to the end of the runtime module, so the address of every statement and every
function can be assigned at compile time.

### Forward jumps

Forward jumps and calls pose a challenge.
Jumps back into already generated code and calls
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
cc64 maintains a list of locations with forward calls. These unresolved
forward calls are why the generated code is only "almost" executable.
They get resolved by the mini linker while copying the generated binary code
into the executable file.

### Variable addresses

Another prerequisite for generating runnable binary code directly from the
parser is this: the addresses of global and static variables need to be
allocated right when each variable is defined, so that any code that uses them
can be generated with the correct absolute address. To achieve this, cc64
allocates global and static variables from the end of the memory available for
variables, because the end of that memory is known before compilation starts,
whereas the start of the memory for variables is typically equal to the end
of the executable code, which of course is only know after compilation ends.

To set these addresses before compiling, cc64 provides the
[`#pragma cc64`](Runtime-libs.md#the-pragma-cc64-directive) preprocessor
command which passes all the needed addresses plus the file name of the runtime
module to the compiler before the first function or variable is defined.
Usually the `#pragma cc64` line lives at the top of the header file that
comes with the runtime module, and the main program just needs to include the
runtime module header file and automatically gets the right address and file
name config for code generator and the mini linker.

More details about the runtime module, its interface used by
the compiled code, and how to write new runtime modules, are
described in [Code layout and library concept](Runtime-libs.md).

## A shortcut to libraries

Finally there's the challenge of libraries: how could things like `stdio.h`,
`ctype.h` or `string.h` and the associated library code be linked into an
executable when not much of a linker is available, and how could the
addresses of their library functions be known at compile time of the main
program so that calls to the functions can be generated with the correct
address during the single compile pass?

It turns out that the runtime module concept can be extended to provide a
library-like experience if one accepts one limitation: A full-featured linker
links only those object files from a library into the final binary that are
actually used by the binary or its dependencies. cc64 doesn't currently offer
this flexibility. Its shortcut (or should it be called a "longcut"?) to
using library functions leads via the option to extend the runtime module.
This is how it works:

If a source file without a main function is compiled, then cc64 doesn't link
it into an executable binary. Instead, it links the newly compiled C code
together with the runtime module it uses into a new runtime module that can
then by used by other compilations. The public symbols of the C code that
gets added to the runtime module are exported via the new runtime module's
header file.

The distribution packages of cc64's releases contain runtime modules named
`libc-c16`, `libc-c64` and `libc-x16` which contain the default minimal
runtime module for the respective platforms plus the full libc, as far as it
is implemented for cc64. Binaries that use the libc runtime modules can use
all libc functions; the shortcut is that they will contain the entire compiled
libc code, not just the libc code they are actually using.

For any given main program, it is of course easy to create a custom runtime
module with just the library functions it needs.

For the future the layered architecture of the code generator, namely the
interface between codegen.fth and v-assembler.fth, may offer an opportunity
for a relocatable intermediate code format, and thereby for a more flexible
linker.
