\ enums and string tables

~ : enum ( -- next-idx 30 )  0 30 ;
~ : y ( last-idx 30 -- next-idx 30 )
    30 ?pairs  dup constant  1+ 30 ;
~ : end-enum ( last-idx 30 -- )  30 ?pairs  drop ;

\ ~ : >string  ( adr -- str )  @ ;
\ ~ : +string  ( adr1 -- adr2/0 ) 2+ ;
~ ' @ alias >string  ( adr -- str )
~ ' 2+ alias +string  ( adr1 -- adr2 )
~ : string[] ( tab n -- adr )  2* + 2+ ;

~ : x ( next-idx 31 -- next-idx 32 )
    31 ?pairs  dup constant  32 ;

~ : x"  ( tab last-idx 32 -- tab next-idx 31 )
    32 ?pairs
    2dup string[] here swap !
    [compile] ,"  1+ 31 ;

~ : string-tab ( size -- tab next-idx 31 )
     create  here swap dup ,  2* allot  0 31 ;

~ : end-tab ( tab next-idx 31 -- )
     31 ?pairs  over @ over -
       IF . ." actual size" cr abort ELSE 2drop THEN ;

~ : length-index  ( stringtab min-idx max-idx -- stringtab 33 )
     create  c, c, dup , 33 ;

~ : end-index  ( stringtab 33 -- )
     33 ?pairs  @ c, ;

~ ' c, alias idx,

~ : find-via-index  ( adr idxtbl -- false )
                    ( adr idxtbl -- token true )
     over c@  over c@ over ( adr idxtbl len idxmaxlen len )
     u< IF drop 2drop false exit THEN ( adr idxtbl len )
     over 1+ c@ - ( adr idxtbl len-idxminlen )
     dup 0< IF drop 2drop false exit THEN
     over + 4 + ( adr idxtbl idxtbl[len-1] )
     swap >r dup 1+ c@ swap c@  r> 2+ @ over string[] -rot
     ( adr str[len-1] token[len-1] token[len] )
     DO ( adr str[len-1] )
       2dup >string streq IF 2drop I true UNLOOP exit THEN
       +string LOOP 2drop false ;
