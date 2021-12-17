
\ parser + codegen unit tests

' noop alias \log

\log include logtofile.fth
\log logopen prs-cgn-test.log

  include base-setup.fth
  include scan-setup.fth

  include parser-setup.fth

  : init-fake-statics  $a000 >staticadr ;
  init: init-fake-statics

  cr .( GOLDEN-SECTION-START) cr

  src-begin test-global-definitions
    src@ int i = 0; @
    src@ static char x; @
    src@ extern char a *= 0x0a; @
    src@ static int e *= 0x0e; @
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

  src-begin test-int-array-init
    src@ static int a[3]; @
    src@ static int b[3] = {1, 2, 3}; @
    src@ static int d[3] = {4, 5}; @
    src@ static int e[]  = {7, 8, 9}; @
    src@ static int f[2] = {10, 11, 12}; @
  test-begin
    T{ definition? -> true }T cr
    T{ definition? -> true }T cr
    T{ definition? -> true }T cr
    T{ definition? -> true }T cr
    T{ definition? -> true }T cr
    *initer* expect-error
    T{ fetchglobal" a" nip -> %int %pointer + }T
    T{ fetchglobal" b" nip -> %int %pointer + }T
    T{ fetchglobal" d" nip -> %int %pointer + }T
    T{ fetchglobal" e" nip -> %int %pointer + }T
    T{ fetchglobal" f" nip -> %int %pointer + }T
  test-end

  src-begin test-char-array-init
    src@ static char a[4]; @
    src@ static char b[4] = "abc"; @
    src@ static char d[4] = "de"; @
    src@ static char e[]  = "ghi"; @
    src@ static char f[3] = "jkl"; @
  test-begin
    T{ definition? -> true }T cr
    T{ definition? -> true }T cr
    T{ definition? -> true }T cr
    T{ definition? -> true }T cr
    T{ definition? -> true }T cr
    *initer* expect-error
    T{ fetchglobal" a" nip -> %pointer }T
    T{ fetchglobal" b" nip -> %pointer }T
    T{ fetchglobal" d" nip -> %pointer }T
    T{ fetchglobal" e" nip -> %pointer }T
    T{ fetchglobal" f" nip -> %pointer }T
  test-end

  src-begin test-local-init
    src@ static int  a = 1; @
    src@ static char b = '2'; @
    src@ static char d[] = 1234; @
    src@ int  e = 3; @
    src@ char f = '4'; @
    src@ char g[] = 5678; @
  test-begin
    T{ declaration? -> true }T cr
    T{ declaration? -> true }T cr
    T{ declaration? -> true }T cr
    T{ declaration? -> true }T cr
    T{ declaration? -> true }T cr
    T{ declaration? -> true }T cr
    T{ fetchlocal" a" nip -> %l-value %int + }T
    T{ fetchlocal" b" nip -> %l-value }T
    T{ fetchlocal" d" nip -> %l-value %pointer + }T
    T{ fetchlocal" e" nip -> %l-value %offset + %int + }T
    T{ fetchlocal" f" nip -> %l-value %offset + }T
    T{ fetchlocal" g" nip -> %l-value %offset + %pointer + }T
  test-end

  src-begin test-local-no-init
    src@ static int  a; @
    src@ static char b; @
    src@ static char d[]; @
    src@ int  e; @
    src@ char f; @
    src@ char g[]; @
  test-begin
    T{ declaration? -> true }T cr
    T{ declaration? -> true }T cr
    T{ declaration? -> true }T cr
    T{ declaration? -> true }T cr
    T{ declaration? -> true }T cr
    T{ declaration? -> true }T cr
    T{ fetchlocal" a" nip -> %l-value %int + }T
    T{ fetchlocal" b" nip -> %l-value }T
    T{ fetchlocal" d" nip -> %l-value %pointer + }T
    T{ fetchlocal" e" nip -> %l-value %offset + %int + }T
    T{ fetchlocal" f" nip -> %l-value %offset + }T
    T{ fetchlocal" g" nip -> %l-value %offset + %pointer + }T
  test-end

  src-begin test-func-call
    src@ int f() *= 0x8004; @
    src@ int main() { @
    src@   f(0x41); @
    src@ } @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
  test-end

  src-begin test-func-fastcall
    src@ _fastcall int f() *= 0x8007; @
    src@ int main() { @
    src@   f(0x42); @
    src@ } @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
  test-end

  src-begin test-func-ptr-call
    src@ int f() *= 0x800a; @
    src@ int main() { @
    src@   int (*g)() = f;
    src@   (*g)(0x43); @
    src@ } @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
  test-end

  src-begin test-func-ptr-fastcall
    src@ _fastcall int f() *= 0x800d; @
    src@ int main() { @
    src@   _fastcall int (*g)() = f;
    src@   (*g)(0x44); @
    src@ } @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
  test-end

  cr .( GOLDEN-SECTION-END) cr
  cr hex .( here, s0: ) here u. s0 @ u.

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
