\ *** Block No. 12, Hexblock c

\ memman: loadscreen           20sep94pz

  cr .( module memman ) cr

\ terminology / interface:
\    himem
\    heap[    ]heap
\    hash[    ]hash
\    symtab[  ]symtab
\    static[  ]static
\    code[    ]code
\    linebuf

\    /linebuf
\    #globals
\    /link
\    /symbol
\    /id

\    init-mem

\    .mem


\ *** Block No. 13, Hexblock d

\   memman: variable           03sep94pz

| create cc64mem  100   ,
              1000  , 4000  , 4000 ,
              0 , 0 , 0 , 0 , 0 ,

  ' limit alias himem

| : #links        cc64mem @ ;
~ : #globals      cc64mem 2+ @ ;
| : symtabsize    cc64mem 4 + @ ;
| : codesize      cc64mem 6 + @ ;
  : lomem          r0 @ ;

~ 6 constant /link   \ listenknoten

~ 4 constant /symbol \ datenfeldgroesse

~ 31 constant /id  \ darf nicht kleiner
   \ als das kuerzeste keyword sein !!!

~ 133 constant /linebuf


\ *** Block No. 14, Hexblock e

\   memman: configure          03sep94pz

~ ' himem ALIAS   ]heap
~               : heap[    cc64mem  8 + @ ;
~ ' heap[ ALIAS   ]hash
~               : hash[    cc64mem 10 + @ ;
~ ' hash[ ALIAS   ]symtab
~               : symtab[  cc64mem 12 + @ ;
~ ' symtab[ ALIAS ]code
~               : code[    cc64mem 14 + @ ;
~ ' code[ ALIAS   ]static
~               : static[  cc64mem 16 + @ ;
~ ' lomem ALIAS   linebuf

| : (conf?  ( -- flag )
     himem  #links /link *  -
                      dup cc64mem  8 + !
     #globals 2*  -   dup cc64mem 10 + !
     symtabsize -     dup cc64mem 12 + !
     codesize   -         cc64mem 14 + !
     linebuf /linebuf +   cc64mem 16 + !
     static[ 11 + ]static u> ;


\ *** Block No. 15, Hexblock f

\   memman: .mem               24aug94pz

~ : configure  ( -- )
     (conf?   *memsetup* ?fatal ;

   init: configure

| : set-mem:  ( n -- ) create c, does>
  ( n dfa -- ) c@ cc64mem + ! ;

~ 0 set-mem: #links!
~ 2 set-mem: #globals!
~ 4 set-mem: symtabsize!
~ 6 set-mem: codesize!

~ : himem!  ['] limit >body ! ;


\ | create (default-mem  $20   ,
\                $10   , $100  , $100  ,

\ ~ : default-mem  ( -- )
\   (default-mem cc64mem 8 cmove configure ;


\ *** Block No. 16, Hexblock 10

\   memman:                    09sep94pz

| : .bytes  ( n -- )  . ." bytes" cr ;

~ : .mem ( -- )
     (conf? cr
    ." data stack  : " s0 @ pad - 256 -
                       .bytes
    ." return stack: " r0 @ s0 @ -
                       .bytes
    ." staticbuffer: " ]static static[
                       - .bytes
    ." codebuffer  : " codesize  .bytes
    ." symbol table: " symtabsize .bytes
    ." hash table  : " #globals .
                       ." elements" cr
    ." heap        : " #links .
                       ." links" cr
    ." memory limit: " himem   u. cr
   IF
    ." bad memory setup: staticbuffer !"
   cr THEN ;


\ *** Block No. 17, Hexblock 11

\   memman:                    24aug94pz

| : relocate-tasks  ( newUP -- )
 up@ dup BEGIN  1+ under @ 2dup -
 WHILE  rot drop  REPEAT  2drop ! ;

~ : relocate  ( stacklen rstacklen -- )
 empty  256 max 8192 min  swap
 256 max 8192 min  pad + 256 +
 2dup + 2+ limit u>
 abort" stacks beyond limit"
 under  +   origin $A + !        \ r0
 dup relocate-tasks
 up@ 1+ @   origin   1+ !        \ task
       6 -  origin  8 + ! cold ; \ s0
