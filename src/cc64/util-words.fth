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

~ ' 2* alias cells
~ ' 2+ alias cell+
