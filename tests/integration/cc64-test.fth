
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

  31  constant /id
  4   constant /symbol \ datenfeldgroesse
  6   constant #globals
  100 constant symtabsize
  create hash[ #globals 2+ allot  here constant ]hash
  create symtab[ symtabsize allot  here constant ]symtab
  include symboltable.fth

  include fake-input.fth
  include scanner.fth

  6  constant /link
  10 constant #links
  create heap[  #links /link * allot
  here constant ]heap
  include listman.fth

  include fake-codeh.fth
  include fake-v-asm.fth

  include codegen.fth
  include parser.fth

  init

  cr .( test successful) cr

\log logclose
