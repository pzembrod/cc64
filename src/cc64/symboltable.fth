\ *** Block No. 60, Hexblock 3c

\ symtab: loadscreen           20sep94pz

\ terminology / interface:
\ findlocal    putlocal
\ nestlocal    unnestlocal
\ findglobal   putglobal
\ ( init-symtab )

\ symbol format:
\  [ name$(counted)][ /symbol bytes data ]

\ symbol table format:
\  symtab[//globals//   //locals//]symtab
\           globals>^   ^locals>

\  hash[////pointers to globals/////]hash

\ marks in the local symbol table:
\  end of block local table:  )block
\  end of total local table:  )local


\ *** Block No. 61, Hexblock 3d

\ symtab: div.                 11mar91pz

|| 63 constant /name
|| 255 constant )local   \ marken
|| 254 constant )block   \
\ es muss /name < )block < )local < 256

|| : cutname ( name -- )
     dup c@ /name umin swap c! ;

|| create dummy  /symbol allot

|| variable globals>
|| variable locals>

~ : init-symtab
     hash[ ]hash over - erase
     symtab[ globals> !
     ]symtab 1-  )local over c!
     locals> ! ;

    init: init-symtab


\ *** Block No. 62, Hexblock 3e

\ symtab: locals               14feb91pz

|| : (findloc) ( name endmark -- dfa/0 )
     ]symtab locals> @
     ?DO dup I c@ > not
        IF 2drop 0 UNLOOP exit THEN
     I c@ /name > IF 1
        ELSE over I streq
           IF 2drop I count +
           UNLOOP exit THEN
        I c@ 1+ /symbol + THEN
     +LOOP  *compiler* fatal ;

~ : findlocal ( name -- dfa/0 )
     dup cutname  )local (findloc) ;

~ : findparam ( name -- dfa/0 )
     dup cutname  )block (findloc) ;

|| : spacious? ( n -- flag )
     locals> @ globals> @ - u> 0= ;


\ *** Block No. 63, Hexblock 3f

\   symtab: locals             14feb91pz

~ : putlocal ( name -- dfa )
     dup c@ 0= IF drop dummy exit THEN
     dup cutname   dup )block (findloc)
        IF drop dummy
        *doubledef* error  exit THEN
     dup c@ 1+ /symbol + spacious?
        IF locals> @ /symbol - under
        over c@ 1+ under - under
        locals> !  cmove
        ELSE drop dummy
        *symovfl* error THEN ;

~ : nestlocal ( -- )
     1 spacious? IF locals> @ 1-
     )block over c!  locals> !
     ELSE *symovfl* error THEN ;

~ : unnestlocal ( -- )
     ]symtab locals> @ ?DO
     I c@ )block = IF I 1+ locals> !
                   UNLOOP exit THEN
     LOOP *compiler* fatal ;


\ *** Block No. 64, Hexblock 40

\ symtab: globals              18feb91pz

|| : hash ( name -- n )
     0 swap count bounds
        ?DO 2* I c@ + LOOP ;

\ true/false flag: found name in global symbols
\ dfa: data field address of found symbol
\ adr: address in hash table for name
\ 0: hash table full
|| : (findglb) ( name -- dfa   true )
              ( name -- adr/0 false )
     dup hash #globals u/mod drop
     2* hash[ + dup
     DO I ]hash u< not
        IF hash[ >I THEN
     I @ ?dup
        IF over streq
           IF drop I @ count +  true
           UNLOOP exit THEN
        ELSE drop I  false UNLOOP exit
        THEN
     2 +LOOP drop 0  false ;


\ *** Block No. 65, Hexblock 41

\   symtab: globals            14feb91pz

~ : findglobal ( name -- dfa/0 )
     dup cutname  (findglb) and ;

~ : putglobal  ( name -- dfa )
     dup c@ 0= IF drop dummy exit THEN
     dup cutname  dup (findglb)
        IF 2drop dummy
        *doubledef* error exit THEN
     ?dup 0=
        IF drop dummy
        *glbovfl* error exit THEN
     over c@ 1+ /symbol +  spacious?
        IF globals> @ swap !
        globals> @ over c@ 1+ cmove
        globals> @ count +
        dup  /symbol + globals> !
        ELSE 2drop dummy
        *symovfl* error THEN ;
