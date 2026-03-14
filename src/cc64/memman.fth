
\prof profiler-bucket [memman-mem]

\ memman - provides memory buffers for different cc64 modules

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


\ sizes:

~ 6 constant /link   \ listenknoten

~ 4 constant /symbol \ datenfeldgroesse

~ 31 constant /id  \ darf nicht kleiner
   \ als das kuerzeste keyword sein !!!

~ 133 constant /linebuf


\ cc64mem data structure with offsets:
\ 0: #links 2: #globals 4: symtabsize 6: codesize
\ 8: heap[/]hash 10: hash[/]symtab 12:symtab[/]code
\ 14: code[/]static 16: static[

|| create cc64mem  200   ,
(CX \ C)      200   , 5000  , 5000 ,
(CX           200   , 2500  , 8192 , C)
              0 , 0 , 0 , 0 , 0 ,

\ get-mem: set-mem: - defining words for cc64mem access words

|| : get-mem:  ( n -- ) create c, does>
  ( dfa -- n ) c@ cc64mem + @ ;

|| : set-mem:  ( n -- ) create c, does>
  ( n dfa -- ) c@ cc64mem + ! ;


\ cc64mem access words

~  ' limit alias himem
~  : lomem          r0 @ ;

|| 0 get-mem: #links
~  2 get-mem: #globals
|| 4 get-mem: symtabsize
|| 6 get-mem: codesize

' himem
~ ALIAS ]heap    ~  8 get-mem:   heap[    ' heap[
~ ALIAS ]hash    ~ 10 get-mem:   hash[    ' hash[
~ ALIAS ]symtab  ~ 12 get-mem: symtab[    ' symtab[
(CX \ C) ~ ALIAS ]code  ~ 14 get-mem: code[  ' code[
~ ALIAS ]static    ~ 16 get-mem: static[
~ ' lomem ALIAS   linebuf

(CX ~ $a000 constant code[   ~ $c000 constant ]code  C)
(CX ~ : enable-code[]-bank ( -- ) 1 $9f61 c! ; C)

~ 0 set-mem: #links!
~ 2 set-mem: #globals!
~ 4 set-mem: symtabsize!
(CX \ C) ~ 6 set-mem: codesize!
||  8 set-mem: heap[!
|| 10 set-mem: hash[!
|| 12 set-mem: symtab[!
|| 14 set-mem: code[!
|| 16 set-mem: static[!


\ cc64mem configuration

|| : (conf?  ( -- flag )
     himem  #links /link *  -
                      dup heap[!
     #globals 2*  -   dup hash[!
     symtabsize -     dup symtab[!
(CX drop \ C) codesize -  code[!
     linebuf /linebuf +   static[!
     static[ 11 + ]static u> ;

~ : configure  ( -- )
     (conf?   *memsetup* ?fatal ;

   init: configure


\ memory layout display

|| : .bytes  ( n -- )  . ." bytes" cr ;

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


\ changing data and return stack sizes

|| : relocate-tasks  ( newUP -- )
 up@ dup BEGIN  1+ under @ 2dup -
 WHILE  rot drop  REPEAT  2drop ! ;

~ : relocate  ( stacklen rstacklen -- )
 empty  $100 max $2000 min  swap
 $100 max $2000 min  pad + $100 +
 2dup + 2+ limit u>
 abort" stacks beyond limit"
 under  +   origin $A + !        \ r0
 dup relocate-tasks
 up@ 1+ @   origin   1+ !        \ task
       6 -  origin  8 + ! cold ; \ s0

  \prof [memman-mem] end-bucket
