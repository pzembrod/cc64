\ *** Block No. 60, Hexblock 3c

\ symtab: loadscreen           20sep94pz

\prof profiler-bucket [symtab]

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

|| 255 constant )local   \ marken
|| 254 constant )block   \
\ necessary: /id < )block < )local < 256

|| variable symtab-min-free
|| variable #collisions

~ : .symtab-status  ( -- )
     symtab-min-free @ u. ." symtab bytes free" cr
     \ handy code to view the effect of the used hash function if needed
     \ 0 ]hash hash[ DO I @ 0= IF 1+ ascii . emit ELSE ascii x emit THEN
     \ 2 +LOOP cr u.
     \ ." hash free buckets" cr
     #collisions @ u. ." hash collisions" cr ;

|| : cutname ( name -- )
     dup c@   dup 0= *compiler* ?fatal
     /id umin swap c! ;

|| create dummy  /symbol allot

~  variable globals>
|| variable locals>

|| : init-symtab
     ]symtab symtab[ - symtab-min-free !  #collisions off
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
     I c@ /id > IF 1
        ELSE over I streq
           IF 2drop I count +
           UNLOOP exit THEN
        I c@ 1+ /symbol + THEN
     +LOOP  *compiler* fatal ;

~ : findlocal ( name -- dfa/0 )
     dup cutname  )local (findloc) ;

~ : findparam ( name -- dfa/0 )
     dup cutname  )block (findloc) ;

|| : check-space ( n -- )
     locals> @ globals> @ - symtab-min-free @ umin  symtab-min-free !
     locals> @ globals> @ - u> *symovfl* ?fatal ;


\ *** Block No. 63, Hexblock 3f

\   symtab: locals             14feb91pz

~ : putlocal ( name -- dfa )
     dup cutname   dup )block (findloc)
        IF drop dummy
        *doubledef* error  exit THEN
     dup c@ 1+ /symbol + check-space
     locals> @ /symbol - under
     over c@ 1+ under - under
     locals> !  cmove ;

~ : nestlocal ( -- )
     1 check-space
     locals> @ 1- )block over c!  locals> ! ;

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
        \ for the records: I tried 3 *, 7 *, 17 *, 101 *, and xor
        \ instead of +, and saw no significant performance change
        \ when compiling libc, and the e2e suites.

\ true/false flag: found name in global symbols
\ dfa: data field address of found symbol
\ adr: address in hash table or link field in previous symbol
\      where address of new symbol could be stored.
|| : (findglb) ( name -- dfa  true )
               ( name -- adr false )
     dup >r  hash #globals u/mod drop  ( hash-idx )
     cells hash[ +  ( hash[]-startadr )
        BEGIN dup @ 0= IF rdrop false exit THEN
        ( hash[]-startadr | link-adr )
        @  dup r@ streq  ( name-adr equal? )
           IF count +  true  rdrop exit ( dfa ) THEN
           ( name-adr )
           count + /symbol + ( link-adr )
        dup cell+ globals> @ u> UNTIL *compiler* fatal ;

\ *** Block No. 65, Hexblock 41

\   symtab: globals            14feb91pz

~ : findglobal ( name -- dfa/0 )
     dup cutname  (findglb) and ;

~ : putglobal  ( name -- dfa )
     dup cutname  dup (findglb)
        IF 2drop dummy
        *doubledef* error exit THEN
     dup hash[ ]hash uwithin 0= IF 1 #collisions +! THEN
     over c@ 1+ /symbol + cell+ check-space
     globals> @ swap !
     globals> @ over c@ 1+ cmove
     globals> @ count +
     dup  /symbol +  dup off cell+ globals> ! ;

\prof [symtab] end-bucket
