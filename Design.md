# Design

I'll try to at least start to give an overview of cc64's design.

## Overview

### Main modules

The main and most interesting pieces of the compiler sit in 2 groups
of 4 modules which are between them rather tightly coupled, and
expose a relatively narrow interface to their client modules.

The first module group consists of

- symboltable.fth which contains the global and the local symbol
  table. Both symbol tables share the same memory block, with the
  globals growing from the start upwards and the locals growing
  from the end downwards. The globals additionally have a hash
  table for faster access.
- input.fth which reads source files line by line, calls the
  preprocessor, gives the scanner a char-by-char view of the source,
  and transparently handles include files.
- preprocess.fth which handles
  - `#include` directives by opening new source files via input.fth,
  - `#define` directives with a hack by creating regular C constants
    in the global symbol table
    (i.e. it does *not* do any macro substitution),
  - the `#pragma cc64` directive by which the
    [runtime module](Runtime-libs.md) is chosen and specified.
- scanner.fth which splits the source code into tokens - keywords,
  identifies, numbers, operators and other characters.

Putting and finding local and global symbols, and viewing and
consuming the current token are the main interface exposed to
the second module group which consists of

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

### 1-pass compiler

cc64 is a 1-pass compiler, going over the source code just once,
and producing binary (almost) executable code right away.
Code is generated - and kept in memory - one function at a time,
so that forward jumps in control structures can be patched as soon
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
