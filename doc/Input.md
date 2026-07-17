# Input

## Overview

The input.fth module is responsible for reading the C source files.
This includes invoking the preprocessor for each newly read source line,
and opening and closing include files.
All this happens transparently for the scanner, input's main consumer,
to which input presents the source lines in the form of a char by char view.

Additionally input integrates the preprocessor into the source flow.
Each source line starting with a `#` is passed to the preprocessor instead
of the scanner, and because the preprocessor is a bit of a hack and doesn't
do textual replacement, no further preprocessor handling of lines that don't
start with `#` is needed. Instead, the preprocessor handles `#include`
instructions via calls back to input to open new source files, and passes
`#define` constants directly to the C symbol table, turning them into C
language constants rather than textual macros.

Basic interface words are

### Interface words

#### For scanner.fth

* `char> ( -- c )` returns the current source character, or 0 at EOL.
* `+char ( -- )` moves the input pointer to the next character.
* `nextline ( -- )` reads the next source line.
* `main-eof` - a boolean variable turning true when the main source ends.
* `comment-state` - a boolean-ish state variable used by the scanner.
  != 0 means a comment is open.
* `comment-starts ( -- )` is called by scanner when a comment starts.

#### For preprocessor.fth

* `open-include ( name -- )` opens an include file. `name` is a counted string.
* `clearline ( -- )` makes the current input line be an empty line.
* `comment-state` - see above

#### For invoke.fth

* `open-input ( name -- )` is used, when the compiler is invoked, to open the
  top-level source file.
* `source-name ( -- name )` returns a buffer holding the current source file
  as counted string.

#### For errorhandler.fth

* `printcontext` prints the current source line and then a pointer pointing to
  the current source location read by the scanner.

## Memory

Input uses 2 words from memman.fth:

* `/linebuf` ("per-linebuf") - a constant defining the max length of source
  lines cc64 accepts (currently 133). This includes the trailing newline.
* `linebuf` - a buffer of `/linebuf` bytes length, for holding the current
  source line.

## Line and character handling

Input's interface for the scanner features separate words for looking at the
current character and for moving ahead to the next character. I chose this
instead of a typical `getchar`-like word that fetches a new character on each
call because a scanner always needs to look at the next character before it
can decide whether to consume it as part of the current token or not.

To implement this with a `getchar`-like word would either require a
corresponding `backchar`-like word to push back the current character in
case it doesn't belong to the current token, or the scanner would need to
keep track internally whether the last fetched char had been pushed back
or not. Separate words for looking at the current character and for moving
ahead is much simpler and cheaper in comparison.

> Interestingly, the interface between scanner and parser shares this same
characteristic; often the parser needs to hold the next token against a
number of grammar rules to find the matching one that can actually consume
the token. For this I had initailly, for no specific reason, chosen a
`nexttoken`/`backtoken`-like interface. Profiling showed that the compiler
spent significant time fetching and pushing back tokens; switching to
`thistoken` and `accept` (i.e. move to the next token) saved a surprising
10% of overall compilation time.

The implementation is mostly simple and straightforward:
* `inptr` is a variable that points to the current character in `linebuf`.
* `char> ( -- c )` fetches the char that `inptr` points to. If that char is
  a zero byte, then that's the end of the line.
* `+char ( -- )` increments `inptr`.
* `clearline ( -- )` resets `inptr` to the start of `linebuf` and places
  a zero byte there, making `linebuf` contain an empty line.
* `nextline ( -- )` reads the next source line. Because it transparently
  handles the end of include files, it is a bit more involved and will be
  described together with source file handling.

## Comment state handling

Detecting and skipping comments in the code is due to cc64's architecture
primarily the task of the scanner. However, in two situations the
input module and also the preprocessor need to know about whether a
comment is currently open, and may even need to set the comment state:
* When an include file or input file ends with a comment still open, then
  that's an error, though not a fatal one, and when continuing to parse the
  file that included the erroneous file, comment state is switched off by
  the input module.
* The preprocessor will ignore any `#define`, `#include` or other
  preprocessor instructions if they occur inside a comment.
