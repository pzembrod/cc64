\ *** Block No. 60, Hexblock 3c

\ symtab: loadscreen           20sep94pz

\prof profiler-bucket [symtab]


\ terminology / interface:
\ findlocal    putlocal
\ nestlocal    unnestlocal
\ findglobal   putglobal
\ ( init-symtab )


\ local symbol layout:
\   name: counted string
\   symbol payload field: 2 cells, /sym-payload bytes

\ global symbol layout:
\   name: counted string, max length: /id
\   global payload field: 3 cells, /glb-payload bytes
\   containing:
\     symbol payload field: 2 cells, /sym-payload bytes
\     global link field: 1 cell, forms the linked list for
\       hash collision resolution. pointer in hash[] points to first
\       global symbol with the given hash value. The symbol's glf
\       points to the next symbol with the same hash value. glf = 0
\       terminates the list.

\ relate stack comments:
\ symbol: the address of the entire symbol == the address of the
\       count byte of the name.
\ spfa: symbol payload field address, the default pointer through which
\       the symbol table communicates with parser and codegen
\ glfa: global link field address

\ symbol table layout:
\  symtab[//globals//   //locals//]symtab
\           globals>^   ^locals>

\  hash[////pointers to globals/////]hash

\ marks in the local symbol table:
\  end of block local table:  )block
\  end of total local table:  )local


\ symbol table core payload size
|| 2 cells             constant /sym-payload
\ global symbols have an additional cell for the
\ hash collision resolution link chain.
|| /sym-payload cell+  constant /glb-payload
|| : /sym-pl+  /sym-payload + ;
|| : /glb-pl+  /glb-payload + ;

\ the mark )block is used for limiting search through the local
\ to only the current block. searching until the mark )local searches
\ the entire local symbol table. 
\ necessary: /id < )block < )local < 256
|| 255 constant )local   \ marks the scope of the current function
|| 254 constant )block   \ marks the scope of the current {} block

\ length of a symbol's name, incl. count byte.
|| : >name-len  ( symbol -- len )  c@ 1+ ;
\ length of a local symbol with payload, incl. cases )local and )block
|| : >local-sym-len  ( symbol -- len )
     c@  dup /id > IF drop 1 ELSE 1+ /sym-pl+ THEN ;
\ from one global to the following one
~  : >next-global  ( global -- next-global )  count + /glb-pl+ ;


|| variable symtab-min-free
|| variable min-locals>
|| variable #collisions

~  variable globals>
|| variable locals>

~ : .symtab-status  ( -- )
     globals> @ symtab[ - u.
     ]symtab min-locals> @ - u.
     symtab-min-free @ u.
     ." global/local/free symtab bytes" cr
     \ handy code to view the effect of the used hash function if needed
     \ 0 ]hash hash[ DO I @ 0= IF 1+ ascii . emit ELSE ascii x emit THEN
     \ 2 +LOOP cr u.
     \ ." hash free buckets" cr
     #collisions @ u. ." hash collisions" cr ;

|| : trimname ( name -- )
     dup c@   dup 0= *compiler* ?fatal
     /id umin swap c! ;

|| create dummy  /sym-payload allot

|| : init-symtab
     ]symtab symtab[ - symtab-min-free !  #collisions off
     hash[ ]hash over - erase
     symtab[ globals> !
     ]symtab 1-  )local over c!
     locals> ! ;

    init: init-symtab

|| : (findloc)  ( name end-marker -- spfa/0 )
     ]symtab locals> @ ?DO
        dup I c@ <= IF 2drop 0 UNLOOP exit THEN
        ( name end-marker )
        I c@ /id <= IF over I streq
           ( name end-marker eq-flag )
           IF 2drop I count +  ( spfa )  UNLOOP exit THEN
        THEN
     I >local-sym-len +LOOP  *compiler* fatal ;

~ : findlocal ( name -- spfa/0 )
     dup trimname  )local (findloc) ;

|| : umin!  ( u variable -- )
      under @  umin  swap ! ;

|| : check-space ( n -- )
     locals> @ globals> @ - symtab-min-free umin!
     \ locals> @ globals> @ - symtab-min-free @ umin  symtab-min-free !
     locals> @ globals> @ - u> *symovfl* ?fatal ;


\ *** Block No. 63, Hexblock 3f

\   symtab: locals             14feb91pz

~ : putlocal ( name -- spfa )
     dup trimname   dup )block (findloc)
        IF drop dummy
        *doubledef* error  exit THEN
     ( name )  dup >name-len /sym-pl+ check-space
     ( name )  locals> @ /sym-payload - under
     ( spfa name spfa )  over >name-len under
     ( spfa name /name spfa /name )  - under
     dup min-locals> umin!
     ( spfa name new-symbol /name new-symbol )  locals> !
     ( spfa name new-symbol /name )  cmove
     ( spfa ) ;

~ : nestlocal ( -- )
     1 check-space
     locals> @ 1- )block over c!  locals> ! ;

~ : unnestlocal ( -- )
     ]symtab locals> @ ?DO
     I c@ )block = IF I 1+ locals> !  UNLOOP exit THEN
     I >local-sym-len +LOOP *compiler* fatal ;


\ *** Block No. 64, Hexblock 40

\ symtab: globals              18feb91pz

|| : hash ( name -- n )
     0 swap count bounds
        ?DO 2* I c@ + LOOP ;
        \ for the records: I tried 3 *, 7 *, 17 *, 101 *, and xor
        \ instead of +, and saw no significant performance change
        \ when compiling libc, and the e2e suites.

\ true/false flag: name was found in global symbols
\ spfa: symbol payload field address of found symbol
\ hash[]-or-glf-adr: address in hash table or global link field in
\      previous global where address of new global could be stored.
|| : (findglb) ( name -- spfa  true )
               ( name -- hash[]-or-glf-adr false )
     dup >r  hash #buckets u/mod drop  ( hash-idx )
     cells hash[ +  ( hash[]-adr )
        BEGIN dup @ 0= IF rdrop false exit THEN
        ( hash[]-or-glf-adr )
        @  dup r@ streq  ( name-adr equal? )
           IF count +  true  rdrop exit ( spfa ) THEN
           ( name-adr )
           count + /sym-pl+ ( link-adr )
        dup cell+ globals> @ u> UNTIL *compiler* fatal ;

\ *** Block No. 65, Hexblock 41

\   symtab: globals            14feb91pz

~ : findglobal ( name -- spfa/0 )
     dup trimname  (findglb) and ;

~ : putglobal  ( name -- spfa )
     dup trimname  dup (findglb)
        IF ( name spfa ) 2drop dummy
        *doubledef* error exit THEN
     ( name hash[]-or-glf-adr )
     dup hash[ ]hash uwithin 0= IF 1 #collisions +! THEN
     ( name hash[]-or-glf-adr )  over >name-len /glb-pl+ check-space
     ( name hash[]-or-glf-adr )  globals> @ swap !
     \ new global (at globals> @) has been stored in hash[] table or
     \ global link field of previous global in same hash[] bucket.
     \ now new global starts being populated: name, spf, glf
     ( name )  globals> @ over >name-len cmove
     ( )  globals> @ count +
     ( spfa )  dup  /sym-pl+
     ( spfa glf-adr )  dup off  cell+
     ( spfa end-of-symbol )  globals> ! ;

\prof [symtab] end-bucket
