
' noop alias \log

\log include logtofile.fth
\log logopen prs-def-test.log

  include base-setup.fth
  include scan-setup.fth

  include parser-setup.fth

  src-begin test-func-params
    src@ f(i,p) @
    src@ int i; @
    src@ char *p; @
    src@ g(int j, char *q) @
  test-begin
    T{ %int (declarator -> id-buf %int %function + }T
    T{ id-buf @ -> ascii f $100 * 1+ }T
    T{ fetchlocal" i" -> 0 %int %offset + %l-value + }T
    T{ fetchlocal" p" -> 2 %int %offset + %l-value + }T
    T{ declare-parameters -> }T
    T{ fetchlocal" i" -> 0 %int %offset + %l-value + }T
    T{ fetchlocal" p" -> 2 %offset %l-value + %pointer + }T
    T{ %int (declarator -> id-buf %int %function + }T
    T{ id-buf @ -> ascii g $100 * 1+ }T
    T{ fetchlocal" j" -> 0 %int %offset + %l-value + }T
    T{ fetchlocal" q" -> 2 %offset %l-value + %pointer + }T
  test-end

  src-begin test-param-error-kr
    src@ f(a,b) @
    src@ int a(); @
    src@ char b[2]; @
  test-begin
    T{ %int (declarator -> id-buf %int %function + }T
    T{ declare-parameters -> }T
    *param* expect-error  *param* expect-error
  test-end

  src-begin test-param-error-ansi
    src@ f(int a(),char b[2]) @
  test-begin
    T{ %int (declarator -> id-buf %int %function + }T
    *param* expect-error  *param* expect-error
  test-end

  src-begin test-param-ok-kr
    src@ f(a,b) @
    src@ int (*a)(); @
    src@ char b[]; @
  test-begin
    T{ %int (declarator -> id-buf %int %function + }T
    T{ declare-parameters -> }T
  test-end

  src-begin test-param-ok-ansi
    src@ f(int (*a)(),char b[]) @
  test-begin
    T{ %int (declarator -> id-buf %int %function + }T
  test-end

  src-begin test-func-defdecl-match
    src@ int f() {} @
    src@ int f(); @
    src@ int f(); @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
    T{ declaration? -> true }T
    T{ fetchglobal" f" nip -> %int %function + %extern + }T
    T{ locals-empty? -> true }T
  test-end

  src-begin test-func-def-nomatch
    src@ int f() {} @
    src@ int* f(); @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
    *!=type* expect-error
  test-end
  
  src-begin test-func-decl-nomatch
    src@ int f() {} @
    src@ int* f(); @
  test-begin
    T{ definition? -> true }T
    T{ declaration? -> true }T
    *!=type* expect-error
  test-end
  
  src-begin test-prototype-match
    src@ int f(); @
    src@ int f() {} @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
    T{ fetchglobal" f" nip -> %int %function + %extern + }T
  test-end

  src-begin test-prototype-nomatch
    src@ int* f(); @
    src@ int f() {} @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
    *!=type* expect-error
  test-end

  src-begin test-define-extern
    src@ int k /= 1234; @
    src@ char lex() /= 0x5678; @
    src@ char* moot() *= 017; @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
    T{ locals-empty? -> true }T
    T{ definition? -> true }T
    T{ locals-empty? -> true }T
    T{ fetchglobal" k" -> 1234 %int %l-value + %extern + }T
    T{ fetchglobal" lex" -> $5678 %function %extern + }T
    T{ fetchglobal" moot" ->
       $f %function %extern + %stdfctn + %pointer + }T
  test-end

  src-begin test-defdata-global
    src@ int i, *j, k[]; @
    src@ char o, *p, q[]; @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
    T{ locals-empty? -> true }T
    T{ fetchglobal" i" nip -> %int %l-value + %extern + }T
    T{ fetchglobal" j" nip -> %int %l-value + %extern + %pointer + }T
    T{ fetchglobal" k" nip -> %int %l-value + %extern + %pointer + }T
    T{ fetchglobal" o" nip -> %l-value %extern + }T
    T{ fetchglobal" p" nip -> %l-value %extern + %pointer + }T
    T{ fetchglobal" q" nip -> %l-value %extern + %pointer + }T
  test-end

  src-begin test-defdata-globalstatic
    src@ static int i, *j, k[]; @
    src@ static char o, *p, q[]; @
  test-begin
    T{ definition? -> true }T
    T{ definition? -> true }T
    T{ locals-empty? -> true }T
    T{ fetchglobal" i" nip -> %int %l-value + }T
    T{ fetchglobal" j" nip -> %int %l-value + %pointer + }T
    T{ fetchglobal" k" nip -> %int %l-value + %pointer + }T
    T{ fetchglobal" o" nip -> %l-value }T
    T{ fetchglobal" p" nip -> %l-value %pointer + }T
    T{ fetchglobal" q" nip -> %l-value %pointer + }T
  test-end

  src-begin test-defdata-local
    src@ int i, *j, k[]; @
    src@ char o, *p, q[]; @
  test-begin
    T{ declaration? -> true }T
    T{ declaration? -> true }T
    T{ globals-empty? -> true }T
    T{ fetchlocal" i" nip -> %int %l-value + %offset + }T
    T{ fetchlocal" j" nip -> %int %l-value + %offset + %pointer + }T
    T{ fetchlocal" k" nip -> %int %l-value + %offset + %pointer + }T
    T{ fetchlocal" o" nip -> %l-value %offset + }T
    T{ fetchlocal" p" nip -> %l-value %offset + %pointer + }T
    T{ fetchlocal" q" nip -> %l-value %offset + %pointer + }T
  test-end

  src-begin test-defdata-localstatic
    src@ static int i, *j, k[]; @
    src@ static char o, *p, q[]; @
  test-begin
    T{ declaration? -> true }T
    T{ declaration? -> true }T
    T{ globals-empty? -> true }T
    T{ fetchlocal" i" nip -> %int %l-value + }T
    T{ fetchlocal" j" nip -> %int %l-value + %pointer + }T
    T{ fetchlocal" k" nip -> %int %l-value + %pointer + }T
    T{ fetchlocal" o" nip -> %l-value }T
    T{ fetchlocal" p" nip -> %l-value %pointer + }T
    T{ fetchlocal" q" nip -> %l-value %pointer + }T
  test-end

  src-begin test-defdata-localarrays
    src@ static int i[] = {1,2,3}, j[5], k[4] = {1,2}; @
  \ TODO: Enable tests again after fixing issue/27
  \ or remove them.
  \  src@ char o[] = "abc", p[3], q[] = {1,2,3,0}; @
  \  src@ int x[] = {1,2,3}, y[3], z[4] = {1,2}; @
  test-begin
    T{ declaration? -> true }T
  \  T{ declaration? -> true }T
  \  T{ declaration? -> true }T
    T{ globals-empty? -> true }T
    T{ fetchlocal" i" nip -> %int %pointer + }T
    T{ fetchlocal" j" nip -> %int %pointer + }T
    T{ fetchlocal" k" nip -> %int %pointer + }T
  \  T{ fetchlocal" o" nip -> %pointer %offset + }T
  \  T{ fetchlocal" p" nip -> %pointer %offset + }T
  \  T{ fetchlocal" q" nip -> %pointer %offset + }T
  \  T{ fetchlocal" x" nip -> %int %pointer + %offset + }T
  \  T{ fetchlocal" y" nip -> %int %pointer + %offset + }T
  \  T{ fetchlocal" z" nip -> %int %pointer + %offset + }T
  test-end

  src-begin test-bad-func-def
    src@ int f(), g(){ @
  test-begin
    T{ definition? -> true }T
    T{ fetchglobal" f" nip -> %int %function + %extern + %proto + }T
    T{ thisword accept -> ascii { #char# }T
    *syntax* expect-error
    *expected* expect-error
  test-end


  cr hex .( here, s%proto + 0: ) here u. s0 @ u.

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
