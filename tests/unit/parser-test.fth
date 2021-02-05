
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen" parser-test.log"

  ' noop   alias ~
  ' noop  alias ~on
  ' noop  alias ~off

  (64 include tmpheap.fth C)
  (64 $2000 mk-tmp-heap C)
  (16 include notmpheap.fth C)

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
  tmpclear

  include fake-memsym.fth
  include symboltable.fth
  tmpclear

  include fake-input.fth
  include scanner.fth
  tmpclear

  include fake-memheap.fth
  include listman.fth
  tmpclear

  include fake-codeh.fth
  include fake-v-asm.fth

  include codegen.fth

  include notmpheap.fth

  include parser.fth

  include tester.fth

  : fetchglobal"  ascii " word findglobal 2@ ;

  src-begin test-src1
  src@ int i; @
  src@ static char x; @
  src@ extern char a /= 0x0a; @
  src@ static int e /= 0x0e; @
  src-end
  
  init  $a000 >staticadr

  test-src1
  T{ definition? -> true }T
  T{ definition? -> true }T
  T{ definition? -> true }T
  T{ definition? -> true }T
  T{ definition? -> false }T

  T{ fetchglobal" i" -> $9ffe %int %extern %reference + + }T
  T{ fetchglobal" x" -> $9ffd %reference }T
  T{ fetchglobal" a" -> $0a %extern %reference + }T
  T{ fetchglobal" e" -> $0e %int %reference + }T

  cr hex .( here, s0: ) here u. s0 @ u.

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
