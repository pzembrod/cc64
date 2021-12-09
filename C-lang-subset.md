# cc64 language restrictions

cc64 was inspired by Ron Cain and James E. Hendrix'
[Small C compiler](https://en.wikipedia.org/wiki/Small-C) for
8080 CPUs and supports a similar subset of the C language.


## C language limitations

- As of v0.10, cc64 supports ANSI-style function
parameter declarations.
- Only (signed) int and (unsigned) char as basic data types.
- No unsigned. No long.
- No floats. No void.
- No structs, no unions.
- No typedef, no enum.
- No type casts.
- Only one level of pointer (nothing like `char **p`). Only 1-dim arrays,
accordingly.
- No goto.
- No nested switch statements.
- No implicit `int f(int i)` function declaration.
All functions must be declared or defined before first calling them.
- No real preprocessor.
  - `#define` just defines a constant on the compiler level. There's no
text substitution as such.
  - Accordingly no macros with parameters. No #undef. No #ifdef/#ifndef.
  - `#include` works as expected, with max 4 levels of include files.
  - `#pragma cc64` defines the memory layout for the code generator and is
described in [runtime libraries](Runtime-libs.md).


## C extensions

cc64 supports two non-standard extensions.

### extern declarations with *=

*= assigns an explicit value to a symbol in an extern declaration:

```
extern int i *= 0x9ffe;
extern char fgetc() *= 0xa02;
```
declares a static int variable at storage location 0x9ffe and a
char-valued function fgetc() at code location 0xa02.

This is indended for use in header files for enhanced 
[runtime libraries](Runtime-libs.md) and not for use in hand-written C code.

### function type modifier `_fastcall`

The `_fastcall` modifier for function declarations is intended
for functions that are implemented in assembly elsewhere.
`_fastcall` routine can take one `char` parameter in a or one
`int` parameter in a/x or no parameter at all and can return a
`char` value in a or an `int` value in a/x.
cc64 calls `_fastcall` functions with a simple and fast `jsr`
without allocating a stack frame on the local variable stack.

`_fastcall` functions must be assigned their address with *=
declarations. E.g.

```
extern _fastcall char chrin()  *= 0xffcf;
extern _fastcall char chrout() *= 0xffd2;
```
makes the C64 Kernal routines CHRIN and CHROUT accessible from cc64
C code.
Note that the return type of chrout() has been chosen as char though the
routine doesn't return anything except in case of an error which is signaled
by the Kernal via a set carry flag, but cc64 can't check that.

One caveat: A `_fastcall` function's name will evaluate to its address, but it
can't be called through a function pointer variable, as the parameter wouldn't
be passed properly. `_fastcall` function pointers should be possible but don't
work yet.

Obviously it would also be attractive to enable `_fastcall` parameter passing even
for C functions that don't have local variables and only one parameter.
