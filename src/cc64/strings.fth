\ strcmp                       09may94pz

~ : strcmp  ( str1 str2 -- flag )
   count rot count rot over =
      IF 0 ?DO
      over I + c@  over I + c@ -
        IF 2drop false UNLOOP exit THEN
      LOOP 2drop true
      ELSE drop 2drop false THEN ;

~ : strcpy  ( src dst -- )
     over c@ 1+ move ;

~ : strcat  ( src dst -- )
     swap count >r over count + r@ move
     dup c@ r> + swap c! ;


  here ascii a ascii A xor $ff xor c, >label FoldCases

~ Code alpha?  ( c -- flag )
    SP )y lda 0<> ?[  label PutFalse  txa
      label PutAA  SP x) sta  SP )y sta  Next jmp ]?
    SP x) lda
    label ContinueAlpha ascii _ # cmp  0= ?[
      label PutTrue  $ff # lda  PutAA bne ]?
    FoldCases and  $41 # cmp  PutFalse bcc
    $5b # cmp  PutFalse bcs  PutTrue bcc
  end-code

~ Code num?  ( c -- flag )
    SP )y lda  PutFalse bne
    SP x) lda  ascii 0 # cmp  PutFalse bcc
    ascii 9 1+ # cmp  PutFalse bcs  PutTrue bcc
  end-code

~ Code alphanum?  ( c -- flag )
    SP )y lda  PutFalse bne
    SP x) lda  ascii 0 # cmp  PutFalse bcc
    ascii 9 1+ # cmp  PutTrue bcc  ContinueAlpha bcs
  end-code

\ ~ : alpha?  ( c -- flag )
\     dup  ascii a ascii [ uwithin
\     over ascii A ascii { uwithin or  \ }
\     swap ascii _ = or ;

\ ~ : num?  ( c -- flag )
\     ascii 0  ascii :  uwithin ;

\ ~ : alphanum? ( c -- flag )
\     dup alpha?  swap num?  or ;


