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


## Runtime module interface

Key to cc64's interface to the runtime module based on which compiled code is
generated is the `#pragma cc64` directive. It takes 7 integer and one string
parameter and has the following form:

`#pragma cc64` *cc-sp*, *zp*, *rt-start*, *rt-jumplist*, *rt-end*,
*statics-start*, *statics-end*, *rt-basename*

The integer params are all memory addresses, typically given in hex.

*cc-sp*: a zero page address pair used as stack pointer for C local variables  
*zp*: a second zero page address pair that the compiled code may use  
*rt-start*: the first code address of the runtime module  
*rt-jumplist*: the address of the runtime modules jump list (see below)  
*rt-end*: the first free code address after the end of the runtime module  
*statics-start*: the lowest address of the runtime module's static vars  
*statics-end*: the hightest address + 1 of the runtime module's static vars  
*rt-basename*: the base filename of the runtime module. *basename*.o is then the
code, *basename*.i the initialzation values of the module's static vars. (Of
course *basename*.h is the header file containing the module's symbol
definitions and the #pragma cc64 directive.)

The compiler accesses the library via a jump list with the following structure:

jumplist
main.adr   .word 0   ; Here the main()-function's address is inserted
                     ; by the compiler. The lib's init routine should
                     ; call main() by a jmp (main.adr)
code.last  .word 0   ; At these addresses the compiler places the last
init.first .word 0   ; address + 1 of the generated code and the first
init.last  .word 0   ; address and the last address + 1 of the static
; variables. Statics are allocated from the end of the used memory
; downwards. The statics' initialization values are stored by the
; compiler from code.last and in reversed order. Your initialization
; routine should copy (code.last) to (init.last) - 1, (code.last) + 1 to
; (init.last) - 2 and so an. Mind: there may be no static variables,
; then init.first will be equal to init.last.
           jmp (zp)   ; Just have this explicitly standing here; it is
                      ; used to emulate jsr (zp). zp is the second zero
                      ; page pointer used by the compiler.
           jmp switch ; Is called with a/x containing a 16 bit value.
                      ; Following the calling jsr-instruction is a data
                      ; structure described below containing values
                      ; and addresses to jump to if a/x matches a value.
                      ; The switch routine should find that data
                      ; structure and jump to the corresponding
                      ; address if a/x matches a value in the list.
                      ; If no value matches it should jump behind the list.
           jmp mult   ; Should multiply (signed) the content of a/x
                      ; (a:lo-byte, x:hi-byte) with the integer in zp/zp+1
                      ; leaving the result in a/x.
           jmp divmod ; Should divide (signed) zp/zp+1 by a/x, leaving
                      ; the result in a/x and the remainder in zp/zp+1.
           jmp shl    ; Should arithmetically shift left a/x by y bits.
           jmp shr    ; Should arithmetically shift right a/x by y bits.

This jumplist may be positioned anywhere in the library; it's address
must be told to the compiler with the described #special command.
The Your library should have a init routine which finally will call
the program's main()-function. In which way this routine is called is up
to You. bl02 uses a BASIC line to start init. If You want programs to
run in $c000-$d000, You might want init to stand at the beginning of
the library so You can call Your programs with SYS49152.
However, the init routine should do two things before calling main()
with a jmp (main.adr) instruction. It should copy the static
variables' initialization values to the variables' actual addresses as
described above. And it should set the software stack pointer to an
initial value. The software stack is used for the allocation of local
variables and grows to high addresses. Its stack pointer therefore
should be set either to the code.last address or to
code.last + init.last - init.first, i.e. behind the statics'
initialization values. The former gives more memory for local
variables, but the software stack will destroy the init values. bl02
employs the latter alternative.

This way the compiler is completely flexible
concerning the surrounding in which the compiled code shall run, and
by creation of a suitable runtime library it is no problem to create
programs which will run in the 64's BASIC memory (as bl02 does), or
use all memory from $0801 to $d000, or just $c000 to $d000, or run on
any other 6502-based computer.
