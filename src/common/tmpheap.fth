

User tmpheap[
User tmpheap>
User ]tmpheap

| : mk-tmp-heap  ( size -- )
    heap dup ]tmpheap ! tmpheap> !  hallot  heap tmpheap[ ! ;

| : tmp-hallot  ( size -- addr )
    tmpheap> @ swap -
    dup tmpheap[ @ u< abort" tmp heap overflow"
    dup tmpheap> ! ;

| : tmp-heapmove   ( from from size -- from offset )
   dup tmp-hallot  swap cmove
   tmpheap> @ over - ;

| : tmp-heapmove1x   ( from size -- from offset )
   heapmove  ?heapmovetx off ;

: |     ['] heapmove1x  ?heapmovetx ! ;
: |on   ['] heapmove    ?heapmovetx ! ;
: |off  ?heapmovetx off ;

