
~ User tmpheap[
~ User tmpheap>
~ User ]tmpheap

heap dup ]tmpheap !  dup tmpheap> !  tmpheap[ ! 

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
   tmp-heapmove  ?heapmovetx off ;

~ : ||     ['] tmp-heapmove1x  ?heapmovetx ! ;
~ : ||on   ['] tmp-heapmove    ?heapmovetx ! ;
~ : ||off  ?heapmovetx off ;


| : remove-tmp-words-in-voc  ( voc -- )
  BEGIN dup @ ?dup WHILE  ( thread next-in-thread )
    dup tmpheap[ @ ]tmpheap @ uwithin IF  ( thread next-in-thread )
      @ ?dup IF ( thread next-next-in-thread ) over ! 
      ELSE ( thread ) off exit THEN
    ELSE ( thread next-in-thread ) nip
    THEN
  REPEAT drop ;

| : remove-tmp-words ( -- )
 voc-link  BEGIN  @ ?dup
  WHILE  dup 4 - remove-tmp-words-in-voc REPEAT  ;

~ : tmpclear  ( -- )
 remove-tmp-words
 tmpheap> @ tmpheap[ @ - cr u. ." tmpheap spare"
 ]tmpheap @ tmpheap> !  last off ;
