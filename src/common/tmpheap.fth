
\ This is the reference implementation of tmpheap which allocates
\ the tmpheap on the regular heap and moves definitons prefixed
\ with || or within a ||on to ||off range onto the tmpheap.
\ tmp-clear will remove all words on the tmpheap, wheras regular clear
\ will remove all words on tmpheap and heap together.

\ Before the first use of ||, the tmpheap size in bytes must be
\ set with mk-tmp-heap ( size -- )

~ User tmpheap[
~ User tmpheap>
~ User ]tmpheap

~ : reset-tmp-heap  ( -- )
  up@ dup ]tmpheap !  dup tmpheap> !  tmpheap[ ! ;

reset-tmp-heap
' reset-tmp-heap is custom-remove

~ : mk-tmp-heap  ( size -- )
    heap dup ]tmpheap ! tmpheap> !  hallot  heap tmpheap[ ! ;

~ : tmp-hallot  ( size -- addr )
    tmpheap> @ swap -
    dup tmpheap[ @ u< abort" tmp heap overflow"
    dup tmpheap> ! ;

| : tmp-heapmove   ( from from size -- from offset )
   dup tmp-hallot  swap cmove
   tmpheap> @ over - ;

| : tmp-heapmove1x   ( from size -- from offset )
   tmp-heapmove  ?headmove-xt off ;

~ : ||     ['] tmp-heapmove1x  ?headmove-xt ! ;
~ : ||on   ['] tmp-heapmove    ?headmove-xt ! ;
~ : ||off  ?headmove-xt off ;


| : remove-tmp-words-in-voc  ( voc -- )
  BEGIN dup @ ?dup WHILE  ( thread next-in-thread )
    dup tmpheap[ @ ]tmpheap @ uwithin IF  ( thread next-in-thread )
      @ ?dup IF ( thread next-next-in-thread ) over ! 
      ELSE ( thread ) off exit THEN
    ELSE ( thread next-in-thread ) nip
    THEN
  REPEAT drop ;

| : remove-tmp-words  ( -- )
  voc-link  BEGIN  @ ?dup
  WHILE  dup 4 - remove-tmp-words-in-voc REPEAT  ;

~ : tmp-clear  ( -- )
  remove-tmp-words
  \ Uncomment the following line to help determine the ideal tmpheap
  \ size for your project.
  \ tmpheap> @ tmpheap[ @ - cr u. ." spare tmpheap bytes"
  ]tmpheap @ tmpheap> !  last off ;
