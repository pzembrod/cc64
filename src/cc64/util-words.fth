\ *** Block No. 6, Hexblock 6

\ do-loop tools                26may91pz

\ needs unloop                         (
\ ) : unloop  r> rdrop rdrop rdrop >r ;

~ : >I  ( n -- )
    r> rdrop swap r@ - >r >r ;

~ : >lo/hi ( u -- lo hi )
     $100 u/mod ;

  \ : lo/hi> ( lo hi -- u )
  \    255 and 256 * swap 255 and + ;

~ : :does>  here >r [compile] does>
    current @ context !  hide 0 ] ;


\ *** Block No. 7, Hexblock 7

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


\ *** Block No. 8, Hexblock 8

\ doer/make (interaktiv)       02sep94pz

  here 0 ] ;
~ : doer  ( -- )
      create  [ swap ] literal ,
      does> @ [ assembler ] ip
              [ forth ]     ! ;

~ : make  ( -- )
      here ' >body ! [compile] ] 0 ;


~ : 2@  ( adr -- d)  dup 2+ @ swap @ ;
~ : 2!  ( d adr --)  under !  2+ ! ;
