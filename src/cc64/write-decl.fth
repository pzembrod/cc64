
\ write-symbols and write-symbol-decl are words of minilinker,
\ with special knowledge about internals of codegen and symbol table.

\ detail knowledge from codegen:
\ type evaluation words: all the %-constants
\ and the words is? and isn't?
\ detail knowledge from symbol table:
\ how to traverse all global symbols and how to fetch their name,
\ type and value.

\ these words live in their own file, because the used codegen
\ words are part of the private codegen/parser parts where word headers
\ live on the tmpheap that is cleared after the codegen/parser group
\ is compiled. so write-decl.fth is loaded as part of this module group
\ even though it really belongs to the minilinker.

|| : write-symbol-decl  ( symbol -- )
     dup count + sym@ ( name val type -- )
     %extern isn't? IF 2drop drop exit THEN
     %function %l-value %pointer + + isn't?
       IF drop " #define " str!  swap str! hex! cr! exit THEN
     " extern " str!
     %fastcall is? IF " _fastcall " str! THEN
     is-char? IF   " char "
              ELSE " int " THEN str!
     %function %l-value + isn't? >r
     %pointer is? r> and
       IF drop swap str! " [] *=" str! hex!
       ELSE %pointer is? IF ascii * fputc THEN
       %function is?
          IF %l-value isn't?
             IF rot str! ELSE " (*" str!
             rot str! ascii ) fputc THEN
          " ()" str! ELSE rot str! THEN
       "  *=" str!  drop hex! THEN
     "  ;" str!  cr! ;

~ : write-symbols  ( -- )
    symtab[
    BEGIN dup globals> @ u< WHILE
      dup write-symbol-decl  >next-global
    REPEAT drop ;
