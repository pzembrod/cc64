# Sources Overview

Most sources for cc64 live in [src/cc64](src/cc64). Some sources which are
shared with peddi, a small text editor that comes with cc64, live in
[src/common]}(src/common). For building cc64 the sources are all copied
into the same virtual disk drive so the include statements e.g. in
[cc64.fth](src/cc64/cc64.fth) don't reflect the subdirs cc64/ or common/.

The following overview lists the main sources of the compiler:

## symboltable.fth

This contains the global and the local symbol
table. Both symbol tables share the same memory block, with the
globals growing from the start upwards and the locals growing
from the end downwards. The globals additionally have a hash
table for faster access.

The symbol table's interface has words for putting and finding local and global
variables as well as functions and function parameters,
and words for nesting and unnesting local variable scopes.

The symbol table is used by parser, codegen, by the preprocessor and by the
mini linker.

## The input-preprocess-scanner source group

These are three somewhat tightly coupled source files which together expose
an interface to the parser that allows viewing and consuming the current
input token.

### input.fth

reads source files line by line, calls the preprocessor, gives the scanner
a char-by-char view of the source, and transparently handles include files.

### preprocess.fth

The cc64 preprocessor is very simple and a bit of a hack. It doesn't
process entire source files; instead it is called by input.fth for each
source line and handles the following preprocessor commands: ***(directives?)

* `#include` opens a new source file via input.fth.
* `#define` is especially hacky; it creates regular C constants in the
  global symbol table, i.e. it does *not* do any macro substitution.
* `#pragma cc64` selects and configures the [runtime module](Runtime-libs.md)
  to use; this is needed for generating executable binary code with
  absolute addresses right in the one compile pass.

### scanner.fth

The scanner splits the source code into tokens - keywords,
identifies, numbers, operators and other characters. Its interface allows
the parser to view the current token without consuming it, and to move
to the next token.

## The parser-codegen source group

This source group consists of a number of source files layered on top of
each other, each file or module using the service of the module underneath or,
in the case of parser.fth, of the two modules underneath.
The interfaces between the modules are extremely wide, representing entire
instruction sets or sets of grammar nodes.

The interface of the overall module group, however, is very narrow.
It consists of the parser's main entry point `compile-program`.
Its output is binary code and static
variable initialization data written into two files, a list of forward
function calls to resolve, and the main function's address.

### v-assembler.fth

v-assembler is a template engine for binary code snippets implementing
something like a virtual CPU with a 16-bit accumulator.
The VM inherits the 6502 hardware stack which cc64 uses when it converts
C infix expressions into stack postfix code.
The VM also has a software stack via a stack frame "register", really
a 6502 zero page pointer, which is used for local variables and
function parameters.

### codegen.fth

codegen.fth contains the code generating logic for C expressions.
It uses v-assembler's virtual 16-bit CPU and has a structure that
mirrors that of the expression parser: Many parser words have a
corresponding codegen word that they call; in this way the
(virtual) parse tree that the parser generates is immediately
consumed again by the codegen so that the actual tree never materializes.

codegen.fth also precalculates the constant parts of expressions where
the value can already be determined at compile time.

### parser.fth

cc64 has a conventional recursive descent parser.
It consists or 3 parts, for expressions, statements and definitions,
respectively. The expression parser generated its code through codegen.fth.
The statement parser deals mainly with control structures, and (this
surprised me a little) control structure code is simpler than expression
code, so the statement parser directly calls v-assembler.fth without the
need for an extra codegen layer.
Besides codegen and v-assembler, the parser mainly depends on scanner and
the symbol table.

### write-decl.fth

Contains just one word, `(write-decl`, which is a mini linker-specific
interface of codegen. It writes a header file definition for a single
symbol exported by a library. Because it requires knowledge of a few internal
words of `codegen.fth`, it is implemented as part of the parser-codegen source
group.

## minilinker.fth

This is the mini linker mentioned above. The parser/codegen group outputs
two files, `%%code` which contains the generated binary code, and `%%init`
which contains the initialazation values for static variables.
A runtime module also has a code file postfixed `.o` and a
static vars initialization file postfixed `.i`. If the mini linker creates
an executable binary, all for files will get merged into one. If it creates
a new library, the code files get joined into a new `.o` file and the
initialization files get joined into a new `.i` file. In both cases the
unresolved forward calls in `%%code` are resolved.

In the case of creating a new library, a third file is written, a `.h` header
file which contains the correct `#pragma cc64` line and which defines all
symbols that the library exports.

## invoke.fth

This contains the top level word `cc` which invokes compiler and linker
and ties everything together.
