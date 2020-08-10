\ *** Block No. 12, Hexblock c

\ core loadscreen              14sep94pz

| : reset  ( -- )
     $0287 @ $fc00 and >r
     scr> $3ff and r@ or
     [ ' scr> >body ] literal !
     <scr $3ff and r@ or
     [ ' <scr >body ] literal !
     last-row> $3ff and r> or
     [ ' last-row> >body ] literal !

     text[ dup 1st-line> ! line> !
     char off  1.column off
     vir-char off
     #cr text[ c!  #cr ]text 1- c!
     text[ 1+ )text !
     ]text 1- text( ! ;


\ *** Block No. 13, Hexblock d

\   edloop                     14sep94pz

| : edloop ( -- )
     create
    does> ( pfa -- )
     >r  end? off
     BEGIN key dup $60 and
        IF .char
        ELSE dup $1f and 2* swap $80
        and 2/ + r@ + @ execute THEN
\    check-mem
     end? @ UNTIL rdrop ;


\ *** Block No. 14, Hexblock e

\   edloop                     15sep94pz

| edloop edit-page

here ]

 .del-to  .bol     noop     quit-ed
 .del-under .eol   noop     noop
 noop     noop     noop     noop
 noop     .split-line noop  noop
 .del-line .down   noop     .screen
 .del-left noop    noop     savetext
 exit-ed  noop     noop     noop
 noop     .right   .del-from noop

 noop     noop     noop     noop
 noop     .20up    noop     noop
 .20down  noop     noop     noop
 noop     .cr      noop     noop
 noop     .up      noop     .kill-line
 .inst-line noop   noop     noop
 noop     noop     noop     noop
 noop     .left    noop     noop

[ here swap - 128 ?pairs 

 cr .( edit-page okay ! ) cr


\ *** Block No. 15, Hexblock f

\   ed                         14sep94pz

| : ed  ( -- )
     bl word filename /filename move
     filename c@ /filename 1- umin
     filename c!
     (64 reset C)
     loadtext edit-page ;
