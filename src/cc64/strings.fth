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

~ : alpha?  ( c -- flag )
    dup  ascii a ascii [ uwithin
    over ascii A ascii { uwithin or  \ }
    swap ascii _ = or ;

~ : num?  ( c -- flag )
    ascii 0  ascii :  uwithin ;

~ : alphanum? ( c -- flag )
    dup alpha?  swap num?  or ;


