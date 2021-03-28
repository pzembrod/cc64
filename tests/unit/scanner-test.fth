
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen scanner-test.log

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

  do$: string2stack  noop noop noop ;

  init
  src-begin test-src1
  src@ int i;  "asd"     @
  src@ i = c + 5 && 'x'; @
  src-end

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

  init
  src-begin test-operator
  src@ ++ += + -- -= - *= * /= /* bla */ / %= % @
  src@ &= && & |= || | ^= ^ != ! == = @
  src@ <<= << <= < >>= >> >= > ~ @
  src-end

  test-operator
  T{ nextword -> <++> #oper# }T
  T{ nextword -> <+=> #oper# }T
  T{ nextword -> <+> #oper# }T
  T{ nextword -> <--> #oper# }T
  T{ nextword -> <-=> #oper# }T
  T{ nextword -> <-> #oper# }T
  T{ nextword -> <*=> #oper# }T
  T{ nextword -> <*> #oper# }T
  T{ nextword -> </=> #oper# }T
  T{ nextword -> </> #oper# }T
  T{ nextword -> <%=> #oper# }T
  T{ nextword -> <%> #oper# }T
  T{ nextword -> <and=> #oper# }T
  T{ nextword -> <l-and> #oper# }T
  T{ nextword -> <and> #oper# }T
  T{ nextword -> <or=> #oper# }T
  T{ nextword -> <l-or> #oper# }T
  T{ nextword -> <or> #oper# }T
  T{ nextword -> <xor=> #oper# }T
  T{ nextword -> <xor> #oper# }T
  T{ nextword -> <!=> #oper# }T
  T{ nextword -> <!> #oper# }T
  T{ nextword -> <==> #oper# }T
  T{ nextword -> <=> #oper# }T
  T{ nextword -> <<<=> #oper# }T
  T{ nextword -> <<<> #oper# }T
  T{ nextword -> <<=> #oper# }T
  T{ nextword -> <<> #oper# }T
  T{ nextword -> <>>=> #oper# }T
  T{ nextword -> <>>> #oper# }T
  T{ nextword -> <>=> #oper# }T
  T{ nextword -> <>> #oper# }T
  T{ nextword -> <inv> #oper# }T
  T{ nextword -> #eof# }T

  : bl/cr ( I cols -- ) swap 1+ swap mod 0= IF cr ELSE bl emit THEN ;
  : test-word.
    ." testing word." cr
    <while> 1+ 0 DO I #keyword# word. I 6 bl/cr LOOP cr
    <inv> 1+ 0 DO I #oper# word. I 12 bl/cr LOOP cr
    ;
  cr test-word.

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose

  cr hex here u. s0 @ u.
