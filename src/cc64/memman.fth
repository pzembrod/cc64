
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
\    /id

\    init-mem

\    .mem


\ sizes:

~ 6 constant /link   \ list node size

~ 31 constant /id  \ max significant size of identifiers
\ must not be smaller than the longest keyword's length
\ see string-tab keywords in scanner.fth

~ 133 constant /linebuf


\ cc64mem data structure with offsets:
\ 0: #links   2: #globals  4: #globals
\ 6: static[  8: heap[    10: hash[    12: symtab[
\ (except on X16:) 14: symtab%  16: code[
\ The offsets must correspond to the accessors defined with
\ get-mem: and set-mem:
\ Note: The order of values and pointers in cc64mem is different
\ from the layout of the actual buffers in memory.

|| create cc64mem
  ( #links = ) 200 , ( hash% = ) 13 , ( #globals = ) 0 ,
  ( static[ ) 0 , ( heap[ ) 0 , ( hash[ ) 0 , ( symtab[ ) 0 ,
  (CX \ C) ( symtab% = ) 40 , ( code[ ) 0 ,

\ get-mem: set-mem: - defining words for cc64mem access words

|| : get-mem:  ( n -- ) create c, does>
  ( pfa -- n ) c@ cc64mem + @ ;

|| : set-mem:  ( n -- ) create c, does>
  ( n pfa -- ) c@ cc64mem + ! ;


\ cc64mem access words

~  ' limit alias himem
~  : lomem          r0 @ ;

||  0 get-mem: #links
||  2 get-mem: hash%
~   4 get-mem: #globals
|| 14 get-mem: symtab%

|| 250 constant static-size

' himem
\ The order of the following lines determines the layout, from top
\ to bottom, of the buffers in memory, between hime and lomem.
\ This must match the initialization in (conf?.
\ Note: This order is not the same as the order of the pointers in
\ the cc64mem struct.
~ ALIAS ]static  ~  6 get-mem: static[    ' static[
~ ALIAS ]heap    ~  8 get-mem:   heap[    ' heap[
(CX \ C) ~ ALIAS ]code  ~ 16 get-mem: code[  ' code[
~ ALIAS ]symtab  ~ 12 get-mem: symtab[    ' symtab[
~ ALIAS ]hash    ~ 10 get-mem:   hash[    ' hash[
drop
~ ' lomem ALIAS   linebuf

(CX ~ $a000 constant code[   ~ $c000 constant ]code  C)
(CX ~ : enable-code[]-bank ( -- ) 1 $9f61 c! ; C)

~  0 set-mem: #links!
~  2 set-mem: hash%!
||  4 set-mem: #globals!
||  6 set-mem: static[!
||  8 set-mem: heap[!
|| 10 set-mem: hash[!
|| 12 set-mem: symtab[!
(CX \ C) ~ 14 set-mem: symtab%!
(CX \ C) || 16 set-mem: code[!

~ : himem!  ['] limit >body ! ;


\ cc64mem configuration

\ scales value n1 with percentage n% after forcing n% to be between
\ 5% and 95%.
|| : %-scale  ( n1 n% -- n2 )   5 max 95 min  100 */ ;

\ The order of the lines matter; they lay out static[] then heap[] down
\ from himem, then linebuf and hash[ up from lomem, then hash[],
\ symtab[] and (except on the X16) code[] are fit into the free space
\ in between. The layout reflects the definition order of the
\ get-mem: accessors above.
|| : (conf?  ( -- flag )
     ]static static-size     -  static[! \ ]static == himem
     ]heap   #links /link *  -  heap[!   \ ]heap == static[
     linebuf /linebuf        +  hash[!   \ linebuf == lomem
     \     200 = arbitrary minimal remaining memory
     hash[ 200 + heap[ u> IF true exit THEN
     heap[ hash[ -  ( free-mem )
     (CX \ C) symtab%  %-scale    ( mem-for-hash+symtab )
     (CX \ C) dup hash[ + code[!  \ set code[ i.e. ]symtab
     hash% %-scale $fffe and 2 max  ( mem-for-hash )
     dup hash[ + symtab[!  ( mem-for-hash ) 2/ #globals!
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
    ." hash%:   " hash%    . ." %" cr
(CX \ C) ." symtab%: " symtab%  . ." %" cr
    ." memtop:  " himem    u. cr
    \ useful for debugging; uncomment if needed:
    \ base push hex
    \ ." hash[]:   " hash[ u. ]hash u. cr
    \ ." symtab[]: " symtab[ u. ]symtab u. cr
    \ ." code[]:   " code[ u. ]code u. cr
    \ ." heap[]:   " heap[ u. ]heap u. cr
    \ ." static[]: " static[ u. ]static u. cr
   IF
    ." ** bad memory setup"
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
