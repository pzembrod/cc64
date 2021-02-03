
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen" cc64-test.log"

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

  : putglobal cr ." putglobal " dup count type cr putglobal ;
  : findglobal cr ." findglobal " dup count type cr findglobal ;
  include parser.fth

  init
  src-begin test-src1
  src@ int i;       @
  src@ i = c + 5;    @
  src-end
  : test-scanner BEGIN nextword 2dup . . 2dup word. cr
    dnegate #eof# d+ or 0= UNTIL ;
  cr hex
  test-src1 test-scanner

  : findglobal"  ascii " word dup cr count type cr findglobal ;

  src-begin test-src2
  src@ int i; @
  src@ static char c; @
  src-end

  test-src2 definition? cr . cr definition? cr . cr definition? cr . cr

  cr hex here u. s0 @ u.

  cr .( test successful) cr

\log logclose
