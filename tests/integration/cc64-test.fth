
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen" cc64-test.log"

  ' noop   alias ~
  ' noop  alias ~on
  ' noop  alias ~off
  include notmpheap.fth

  : dos  ( -- )
   bl word count ?dup
      IF 8 15 busout bustype
      busoff cr ELSE drop THEN
   8 15 busin
   BEGIN bus@ con! i/o-status? UNTIL
   busoff ;

  onlyforth  decimal
  include util-words.fth
  cr
  vocabulary compiler
  compiler also definitions

  include init.fth

  include strtab.fth
  include errormsgs.fth
  include errorhandler.fth

  \ include fake-memsym.fth
  \ include symboltable.fth

  include fake-input.fth
  \ include scanner.fth

  \ include fake-memheap.fth
  \ include listman.fth

  \ include fake-codeh.fth
  \ include fake-v-asm.fth

  \ include codegen.fth
  \ include parser.fth

  init
  src-begin test-src
  src@ 1  @
  src-end
  \ : test BEGIN nextword dup . . cr dnegate #eof# d+ or 0= UNTIL ;
  \ test-src test

  src@ int i;       @
  src@ i = c + 5    @

  cr .( test successful) cr

\log logclose
