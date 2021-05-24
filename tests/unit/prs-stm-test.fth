
' noop alias \log

\log include logtofile.fth
\log logopen prs-stm-test.log

  include base-setup.fth
  include scan-setup.fth

  include parser-setup.fth

  src-begin test-stmt
    src@ for @
  test-begin
    T{ statement-tab #keyword# comes-tab-token? -> ' for-stmt true }T
  test-end


  cr hex .( here, s0: ) here u. s0 @ u.

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
