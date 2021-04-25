
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

  include tmpheap.fth
  $2000 mk-tmp-heap

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
  ' id-buf alias idbuf
  tmp-clear

  do$: string2stack  noop noop noop ;
  : nextword  thisword accept ;

  init
  src-begin test-src1
  src@ int i;  "asd"     @
  src@ i = c + 5 && 'x'; @
  src-end

  test-src1 fetchword
  T{ nextword -> <int> #keyword# }T
  T{ nextword -> idbuf #id# }T
  cr .( idbuf: ) idbuf count type cr
  T{ idbuf count swap c@ -> 1  ascii i }T
  T{ nextword -> ascii ; #char# }T
  T{ thisword -> 0 #string# }T
  T{ string2stack -> ascii a  ascii s  ascii d  0 }T
  accept
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
  src-begin test-keyword
  src@ auto break case char continue default @
  src@ do else extern for goto if @
  src@ int register return static switch while @
  src-end

  test-keyword  fetchword
  T{ nextword -> <auto> #keyword# }T
  T{ nextword -> <break> #keyword# }T
  T{ nextword -> <case> #keyword# }T
  T{ nextword -> <char> #keyword# }T
  T{ nextword -> <cont> #keyword# }T
  T{ nextword -> <default> #keyword# }T
  T{ nextword -> <do> #keyword# }T
  T{ nextword -> <else> #keyword# }T
  T{ nextword -> <extern> #keyword# }T
  T{ nextword -> <for> #keyword# }T
  T{ nextword -> <goto> #keyword# }T
  T{ nextword -> <if> #keyword# }T
  T{ nextword -> <int> #keyword# }T
  T{ nextword -> <register> #keyword# }T
  T{ nextword -> <return> #keyword# }T
  T{ nextword -> <static> #keyword# }T
  T{ nextword -> <switch> #keyword# }T
  T{ nextword -> <while> #keyword# }T
  T{ nextword -> #eof# }T

  init
  src-begin test-operator
  src@ ++ += + -- -= - *= * /= /* bla */ / %= % @
  src@ &= && & |= || | ^= ^ != ! == = @
  src@ <<= << <= < >>= >> >= > ~ @
  src-end

  test-operator fetchword
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

  .( SECTION-START) cr
  : bl/cr ( I cols -- ) swap 1+ swap mod 0= IF cr ELSE bl emit THEN ;
  : test-word.
    ." testing word." cr
    <register> 1+ 0 DO I #keyword# word. I 6 bl/cr LOOP cr
    <inv> 1+ 0 DO I #oper# word. I 12 bl/cr LOOP cr
    ;
  cr test-word.
  .( SECTION-END) cr

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose

  cr hex here u. s0 @ u.
