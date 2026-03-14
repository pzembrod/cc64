
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
\ 0: #links 2: #globals 4: unused 6: unused
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
\ || 4 get-mem: symtabsize
\ || 6 get-mem: codesize

|| 250 constant static-size

' himem
\ The order of the following lines determines the layout, from top
\ to bottom, of the buffers in memory, between hime and lomem.
\ This must match the initialization in (conf?.
\ Note: This order is not the same as the order of the pointers in
\ the cc64mem struct.
~ ALIAS ]static  ~ 16 get-mem: static[    ' static[
~ ALIAS ]heap    ~  8 get-mem:   heap[    ' heap[
(CX \ C) ~ ALIAS ]code  ~ 14 get-mem: code[  ' code[
~ ALIAS ]symtab  ~ 12 get-mem: symtab[    ' symtab[
~ ALIAS ]hash    ~ 10 get-mem:   hash[    ' hash[
drop
~ ' lomem ALIAS   linebuf

(CX ~ $a000 constant code[   ~ $c000 constant ]code  C)
(CX ~ : enable-code[]-bank ( -- ) 1 $9f61 c! ; C)

~ 0 set-mem: #links!
~ 2 set-mem: #globals!
\ ~ 4 set-mem: symtabsize!
\ (CX \ C) ~ 6 set-mem: codesize!
||  8 set-mem: heap[!
|| 10 set-mem: hash[!
|| 12 set-mem: symtab[!
(CX \ C) || 14 set-mem: code[!
|| 16 set-mem: static[!

\ (CX ' symtab[! \ C)  ' code[!
\ || ALIAS ]static!
\ (CX \ C)  ' symtab[!  || ALIAS ]code!


\ cc64mem configuration

\ The order of the lines matter; they lay out static[] then heap[] down
\ from himem, then linebuf and hash[ up from lomem, then hash[],
\ symtab[] and (except on the X16) code[] are fit into the free space
\ in between. The layout reflects the definition order of the
\ get-mem: accessors above.
|| : (conf?  ( -- flag )
     ]static static-size     -  static[! \ ]static == himem
     ]heap   #links /link *  -  heap[!   \ ]heap == static[
     linebuf /linebuf        +  hash[!   \ linebuf == lomem
     hash[ 100 + heap[ u> IF true exit THEN
     heap[ hash[ - (CX \ C) 2/  \ size for hash + symtab
     dup 8 / $fffe and dup hash[ + symtab[! 2/ #globals!
     (CX drop \ C) hash[ + code[!
     false ;

~ : configure  ( -- )
     (conf?   *memsetup* ?fatal ;

   init: configure


\ memory layout display

|| : .bytes  ( n -- )  . ." bytes" cr ;

~ : .mem ( -- )
     (conf? cr
    ." stack:   " s0 @ pad - 256  - .bytes
    ." rstack:  " r0 @ s0 @       - .bytes
    ." statics: " ]static static[ - .bytes
    ." code:    " ]code code[     - .bytes
    ." symtab:  " ]symtab symtab[ - .bytes
    ." hashtab: " #globals . ." buckets" cr
    ." heap:    " #links   . ." links" cr
    ." memtop:  " himem    u. cr
    \ useful for debugging; uncomment if needed:
    \ base push hex
    \ ." hash[]:   " hash[ u. ]hash u. cr
    \ ." symtab[]: " symtab[ u. ]symtab u. cr
    \ ." code[]:   " code[ u. ]code u. cr
    \ ." heap[]:   " heap[ u. ]heap u. cr
    \ ." static[]: " static[ u. ]static u. cr
   IF
    ." bad memory setup"
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
