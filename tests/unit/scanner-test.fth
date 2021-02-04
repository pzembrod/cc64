
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen" scanner-test.log"

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

  : cells  2* ;
  : s"  [compile] " compile count ; immediate restrict
  : [char]  [compile] ascii ; immediate

  include tester.fth

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
  ' id-buf alias idbuf
  tmpclear

  init
  src-begin test-src1
  src@ int i;  "asd"     @
  src@ i = c + 5 && 'x'; @
  src-end

  do$: string2stack  noop noop noop ;

  test-src1
  T{ nextword -> <int> #keyword# }T
  T{ nextword -> idbuf #id# }T
  cr idbuf count .s type cr
  T{ idbuf count swap c@ -> 1  ascii i }T
  T{ nextword -> ascii ; #char# }T
  T{ nextword -> 0 #string# }T
  T{ string2stack -> ascii a  ascii s  ascii d  0 }T
  T{ nextword -> idbuf #id# }T
  T{ idbuf count swap c@ -> 1  ascii i }T
  T{ nextword -> <=> #oper# }T
  T{ nextword -> idbuf #id# }T
  T{ idbuf count swap c@ -> 1  ascii c }T
  T{ nextword -> <+> #oper# }T
  T{ nextword -> 5 #number# }T
  T{ nextword -> <l-and> #oper# }T
  T{ nextword -> ascii x  #number# }T
  T{ nextword -> ascii ; #char# }T
  T{ nextword -> #eof# }T

  cr hex here u. s0 @ u.

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
