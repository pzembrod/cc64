# Code layout and library concept

## Code generation concept

cc64 directly produces executable binary code, to avoid the need for an
assembler and a symbolic linker, somewhat like Turbo Pascal 3.0 did.
cc64 generates non-relocatable code, using the end address of
a non-relocatable runtime module as start address for the generated code.


## The #pragma cc64 directive

The choice of the runtime module to use as starting point for code generation
happens with the `#pragma cc64` preprocessor directive which contains the
memory addressess the compiler needs, plus the base name of the runtime module
files. The `#pragma cc64` directive must be processed before the first code or
variable is generated and is usually contained in the runtime module's .h file.

Selecting the desired runtime module happens by including the module's .h
file at the beginning of a module.

For details about the `#pragma cc64` directive see the section about the
[runtime module interface](#runtime-module-interface).


## Runtime module files

A runtime module consists of 3 files:

- *module-name*.h contains the `#pragma cc64` directive and /= declarations for
all global symbols (functions and variables) contained in the module.
See [extern declarations with /=](C-lang-subset.md#extern-declarations-with-)
for details.
- *module-name*.o contains the binary executable code of the module.
- *module-name*.i contains the initialization values for the module's static
variables.


## Extending runtime modules

When cc64 compiles a program without a main() function, the output will not be
an executable binary but a new, extended runtime module containing everything
the base runtime module contains, plus the new compiled code. This can be used
to write extended runtime libraries in C.

Compiling a file *module-name*.c without a main() function will produce
*module-name*.h, *module-name*.o and *module-name*.i as output files.


## Code and memory layout

New code is generated as non-relocatable binary code, starting at the first
free address after the runtime module's code. Static variables are allocated
starting at the end of the available memory and growing downwards.
With this layout, in the case of one contiguous memory area for both code and
data (e.g. $0801 - $a000 on the C64), code and statics can grow towards each
other, the local variable stack can live between them, and yet the compiler
can allocate an absolute address to each static variable the moment it is
defined, when the length of the code is not yet known.

The same layout approach also works for separate code and data memory (e.g.
code in ROM). The only difference is that the runtime module must then
initialize the local variable stack pointer not to the end of the code but
to the beginning of the available RAM.

The local variable stack grows upwards.

The initialization values for the static variables are written to a separate
file during the first compiler pass, and because statics are allocated from
the end of the available memory, the initalization value file contains the
intitialization data *in reverse order*. During the (very simple) second
compiler pass, the reverse order init data are attached to the end of the code,
so the copy loop that writes the data into the static variable memory reverse
the order again while doing so.


## Runtime module interface

cc64 gets the details about memory layout and the runtime module that it needs
to generate code from the `#pragma cc64` directive.
`#pragma cc64` takes 7 integer parameters, all memory addresses usually given
in hex, and one string parameter, a file base name. It has the following form:

`#pragma cc64` *cc-sp*, *zp*, *rt-start*, *rt-jumplist*, *rt-end*,
*statics-start*, *statics-end*, *rt-basename*

- *cc-sp*:
- - a zero page address pair used as stack pointer for C local variables
- *zp*:
- - a second zero page address pair that the compiled code may use
- *rt-start*:
- - the first code address of the runtime module
- *rt-jumplist*:
- - the address of the runtime modules jump list (see below)
- *rt-end*:
- - the first free code address after the end of the runtime module
- *statics-start*:
- - the lowest address of the runtime module's static vars
- *statics-end*:
- - the hightest address + 1 of the runtime module's static vars
- *rt-basename*:
- - the base filename of the runtime module. *basename*.o is then the
code, *basename*.i the initialzation values of the module's static vars. (Of
course *basename*.h is the header file containing the module's symbol
definitions and the #pragma cc64 directive.)

The jumplist mentioned above is the compiler's interface into the runtime
module.  
It has the following structure:

```
rt_jumplist
main_adr   .word 0
code_last  .word 0
statics_first .word 0
statics_last  .word 0
           jmp (zp)
           jmp switch
           jmp mult
           jmp divmod
           jmp shl
           jmp shr
```

The first part of the jumplist is a list of 4 addresses:

- `rt_jumplist`
- - This address (equal to main_addr, of course) is #pragma cc64's 4th param
and the runtime module's anchor for the compiler.
- `main_adr`
- - Here the main()-function's address is inserted by the compiler. The
runtime module's initialization calls main() with a jmp (main.adr).
- `code_last`
- - Here the last address + 1 of the generated code is inserted by the compiler.
- `statics_first`
- - Here the first address of the generated code is inserted by the compiler.
- `statics_last`
- - Here the last address + 1 of the generated code is inserted by the compiler.

As described above, statics are allocated from the end of the used memory
downwards. The statics' initialization values are placed by the
compiler from code_last upwards and in reversed order.
The initialization routine copies (code_last) to (init_last) - 1,
(code_last) + 1 to  (init_last) - 2 and so an to reverse the order again.
In case of no static variables, init_first will be equal to init_last.

After the addresses follows a list of 6 jmp instructions:

- `jmp (zp)`
- - This it is used to emulate `jsr (zp)`. zp is the second zero
page pointer used by the compiler.
- `jmp switch`
- - Code generated for switch statements consists of loading into a/x
the 16 bit value to match to case statements and a jsr to this address.
Following the calling jsr-instruction will be an array of pairs of 16 bit
values, one pair per case statement. The second value in each pair is the case
value, and the first value is the address to jump to in case of a match.
A 16-bit 0 value marks the end of the list. It is followed by either a jump to
the default branch or just the code following the switch statement.
Hence, the `switch` routine gets the start of the list by pulling the jsr
instruction's return address from the stack and adding 1 to it.
It then compares a/x to the 2nd value of each pair, jumps to the pair's first
address in case of match, and in case of no match jumps behind the terminating
0 at the end of the list.
- jmp mult
- - Multiplies (signed) the content of a/x with the integer in zp/zp+1,
leaving the result in a/x.
- jmp divmod
- - Divides (signed) zp/zp+1 by a/x, leaving the result in a/x and the
remainder in zp/zp+1.
- jmp shl
- - Arithmetically shifts left a/x by y bits.
- jmp shr
- - Arithmetically shifts right a/x by y bits.

The jumplist may be positioned anywhere in the library.

A cc64 binary is started by calling the runtime module's init routine which
initializes the static variables as described above, initializes the locals
stack pointer and then jumps, via the jumplist, to the main function.
