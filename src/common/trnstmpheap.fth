
\ This is a variant of the reference implementation tmpheap.fth
\ which places all the code for the tmpheap onto the heap,
\ just like the transient 6502 assembler trns6502asm.fth.
\ So after a SAVE or CLEAR, the tmpheap code is all gone, which is
\ nice since the compiled turnkey application will likely not need
\ it anymore, and so the compile time space saving that tmpheap offers
\ comes at zero cost in turnkey application size.

heap cr .( trnstmpheap max end: ) u. cr

here

$200 hallot  heap dp !

variable tmpheap[
variable tmpheap>
variable ]tmpheap

up@ dup ]tmpheap !  dup tmpheap> !  tmpheap[ !

: mk-tmp-heap  ( size -- )
    heap dup ]tmpheap ! tmpheap> !  hallot  heap tmpheap[ ! ;

: tmp-hallot  ( size -- addr )
    tmpheap> @ swap -
    dup tmpheap[ @ u< abort" tmp heap overflow"
    dup tmpheap> ! ;

: tmp-heapmove   ( from from size -- from offset )
   dup tmp-hallot  swap cmove
   tmpheap> @ over - ;

: tmp-heapmove1x   ( from size -- from offset )
   tmp-heapmove  ?heapmovetx off ;

: ||     ['] tmp-heapmove1x  ?heapmovetx ! ;
: ||on   ['] tmp-heapmove    ?heapmovetx ! ;
: ||off  ?heapmovetx off ;


: remove-tmp-words-in-voc  ( voc -- )
  BEGIN dup @ ?dup WHILE  ( thread next-in-thread )
    dup tmpheap[ @ ]tmpheap @ uwithin IF  ( thread next-in-thread )
      @ ?dup IF ( thread next-next-in-thread ) over ! 
      ELSE ( thread ) off exit THEN
    ELSE ( thread next-in-thread ) nip
    THEN
  REPEAT drop ;

: remove-tmp-words  ( -- )
 voc-link  BEGIN  @ ?dup
  WHILE  dup 4 - remove-tmp-words-in-voc REPEAT  ;

: tmpclear  ( -- )
  remove-tmp-words
  \ Uncomment the following line to help determine the ideal tmpheap
  \ size for your project.
  \ tmpheap> @ tmpheap[ @ - cr u. ." spare tmpheap bytes"
  ]tmpheap @ tmpheap> !  last off ;

here cr .( trnstmpheap act end: ) u. cr

dp !
