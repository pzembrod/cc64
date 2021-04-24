\ *** Block No. 9, Hexblock 9

\ stringtabellen               30sep90pz

|| variable next-idx
|| variable tabsize
|| variable strarray>

~ : x ( -- )  next-idx @  1 next-idx +!  constant ;
~ : x"  ( -- )
    here strarray> @ !  2 strarray> +!
    [compile] ," ;

~ : stringtab ( size -- )
     tabsize !  next-idx off  create
     here strarray> !  tabsize @ 2* allot ;

~ : endtab ( -- )
     next-idx @ tabsize @ -
       IF next-idx @ . ." actual size" cr abort THEN ;

\ ~ : >string  ( adr -- str )  @ ;
\ ~ : +string  ( adr1 -- adr2/0 ) 2+ ;
~ ' @ alias >string  ( adr -- str )
~ ' 2+ alias +string  ( adr1 -- adr2 )
~ : string[] ( tab n -- adr )  2* + ;

~ : findstr2  ( adr idxtbl -- false )
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
