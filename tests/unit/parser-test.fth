
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen parser-test.log

\needs \prof  ' \ alias \prof immediate

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
  include tmp6502asm.fth
  include strings.fth
  cr
  vocabulary compiler
  compiler also definitions

  include init.fth

  include strtab.fth
  include errormsgs.fth
  include errorhandler.fth
  tmp-clear

  include fake-memsym.fth
  include symboltable.fth
  tmp-clear

  include fake-input.fth
  include scanner.fth
  tmp-clear

  include fake-memheap.fth
  include listman.fth
  tmp-clear

  include fake-codeh.fth
  include fake-v-asm.fth

  include codegen.fth

  include notmpheap.fth

  include parser.fth

  include tester.fth

  : fetchglobal"  ascii " word findglobal ?dup IF 2@ THEN ;
  : fetchlocal"  ascii " word findlocal ?dup IF 2@ THEN ;

  src-begin test-src1
  src@ int i = 0; @
  src@ static char x; @
  src@ extern char a /= 0x0a; @
  src@ static int e /= 0x0e; @
  src@ char *p; @
  src-end
  
  init  $a000 >staticadr

  test-src1 fetchword
  T{ definition? -> true }T
  T{ definition? -> true }T
  T{ definition? -> true }T
  T{ definition? -> true }T
  T{ definition? -> true }T
  T{ definition? -> false }T
  T{ thisword -> #eof# }T

  T{ fetchglobal" i" -> $9ffe %int %extern %reference + + }T
  T{ fetchglobal" x" -> $9ffd %reference }T
  T{ fetchglobal" a" -> $0a %extern %reference + }T
  T{ fetchglobal" e" -> $0e %int %reference + }T
  T{ fetchglobal" p" -> $9ffb %extern %reference + %pointer + }T

  src-begin test-stmt
  src@ for @
  src@ for(;;); @
  src@ {for(;;);} @
  src-end

  init  test-stmt fetchword
  T{ statement-tab #keyword# comes-tab-token? -> ' for-stmt true }T
  T{ statement? -> true }T
  T{ statement? -> true }T
  T{ thisword -> #eof# }T

  src-begin test-func
  src@ int f(i,p) @
  src@ int i; @
  src@ char *p; @
  src@ {} @
  src-end

  init  test-func fetchword
  T{ definition? -> true }T
  T{ thisword -> #eof# }T

  src-begin test-func-params
  src@ f(i,p) @
  src@ int i; @
  src@ char *p; @
  src-end

  init  test-func-params fetchword
  T{ %int (declarator -> %int %function + }T
  T{ id-buf @ -> ascii f $100 * 1+ }T
  T{ fetchlocal" i" -> 0 %int %offset + %reference + }T
  T{ fetchlocal" p" -> 2 %int %offset + %reference + }T
  T{ declare-parameters -> }T
  T{ fetchlocal" i" -> 0 %int %offset + %reference + }T
  T{ fetchlocal" p" -> 2 %offset %reference + %pointer + }T
  T{ thisword -> #eof# }T

  cr hex .( here, s0: ) here u. s0 @ u.

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
