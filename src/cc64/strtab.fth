\ *** Block No. 9, Hexblock 9

\ stringtabellen               30sep90pz

|| variable n
|| variable m

~ : x ( -- )  n @  1 n +!  constant ;
~ : x"  ( -- )   here m @ !  here m !
    2 allot  [compile] ," ;

  here 0 ,   | constant nil
  here nil , ," end of table"
             | constant void

~ : stringtab ( -- )
     create  here m !  2 allot  0 n !
    does> ( -- 1.adr )  @ ;
~ : endtab ( -- )  nil m @ ! ;

~ : >string  ( adr -- str )  2+ ;
~ : +string  ( adr1 -- adr2/0 ) @ ;
~ : string[] ( tab n -- adr )
     0 ?DO +string ?dup 0= IF void THEN
    LOOP ;
