
' noop alias \log

\log include logtofile.fth
\log logopen prs-cgn-test.log

  include base-setup.fth
  include scan-setup.fth

  include parser-setup.fth

  : init-fake-statics  $a000 >staticadr ;
  init: init-fake-statics

  .( GOLDEN-SECTION-START) cr

  src-begin test-global-definitions
    src@ int i = 0; @
    src@ static char x; @
    src@ extern char a /= 0x0a; @
    src@ static int e /= 0x0e; @
    src@ char *p; @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
    T{ definition? -> true }T
    T{ definition? -> true }T
    T{ definition? -> true }T
    T{ definition? -> false }T
    cr

    T{ fetchglobal" i" -> $9ffe %int %extern %l-value + + }T
    T{ fetchglobal" x" -> $9ffd %l-value }T
    T{ fetchglobal" a" -> $0a %extern %l-value + }T
    T{ fetchglobal" e" -> $0e %int %l-value + }T
    T{ fetchglobal" p" -> $9ffb %extern %l-value + %pointer + }T
  test-end

  src-begin test-for
    src@ for(;;); @
    src@ {for(;;);} @
  test-begin
    T{ statement? -> true }T
    T{ statement? -> true }T
  test-end

  src-begin test-kr-func
    src@ int f(i,p) @
    src@ int i; @
    src@ char *p; @
    src@ {} @
  test-begin
    T{ definition? -> true }T
  test-end

  .( GOLDEN-SECTION-END) cr
  cr hex .( here, s0: ) here u. s0 @ u.

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
