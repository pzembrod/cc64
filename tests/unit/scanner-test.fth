
' noop alias \log

\log include logtofile.fth
\log logopen scanner-test.log

  include base-setup.fth
  include scan-setup.fth

  do$: string2stack  noop noop noop ;
  : nextword  thisword accept ;


  src-begin test-src1
    src@ int i;  "asd"     @
    src@ i = c + 5 && 'x'; @
  test-begin
    T{ nextword -> <int> #keyword# }T
    T{ nextword -> scn-idbuf #id# }T
    cr .( scn-idbuf: ) scn-idbuf count type cr
    T{ scn-idbuf count swap c@ -> 1  ascii i }T
    T{ nextword -> ascii ; #char# }T
    T{ thisword -> 0 #string# }T
    T{ string2stack -> ascii a  ascii s  ascii d  0 }T
    accept
    T{ nextword -> scn-idbuf #id# }T
    T{ scn-idbuf count swap c@ -> 1  ascii i }T
    T{ nextword -> <=> #oper# }T
    T{ nextword -> scn-idbuf #id# }T
    T{ scn-idbuf count swap c@ -> 1  ascii c }T
    T{ nextword -> <+> #oper# }T
    T{ nextword -> 5 #number# }T
    T{ nextword -> <l-and> #oper# }T
    T{ nextword -> ascii x  #number# }T
    T{ nextword -> ascii ; #char# }T
  test-end


  src-begin test-keyword
    src@ auto break case char continue default @
    src@ do else extern for goto if @
    src@ int register return static switch while @
  test-begin
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
  test-end


  src-begin test-operator
    src@ ++ += + -- -= - *= * /= /* bla */ / %= % @
    src@ &= && & |= || | ^= ^ != ! == = @
    src@ <<= << <= < >>= >> >= > ~ @
  test-begin
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
  test-end

  src-begin test-char
    src@ ? : @
  test-begin
    T{ nextword -> ascii ? #char# }T
    T{ nextword -> ascii : #char# }T
  test-end

  .( GOLDEN-SECTION-START) cr
  init
  : bl/cr ( I cols -- ) swap 1+ swap mod 0= IF cr ELSE bl emit THEN ;
  : test-word.
    ." testing word." cr
    <register> 1+ 0 DO I #keyword# word. I 6 bl/cr LOOP cr
    <inv> 1+ 0 DO I #oper# word. I 12 bl/cr LOOP cr
    ;
  cr test-word.
  check-error-messages
  .( GOLDEN-SECTION-END) cr

  cr hex .( here, s0: ) here u. s0 @ u.

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
