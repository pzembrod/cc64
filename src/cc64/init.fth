\ *** Block No. 10, Hexblock a

\ init                         18apr94pz

\prof profiler-bucket [memman-init]

|| variable inits  inits off

~ : init  ( -- )
     inits BEGIN @ ?dup WHILE
           dup 2+ perform REPEAT ;

~ : init: ( name )
     inits BEGIN dup @ WHILE @ REPEAT
     here swap !  0 ,  ' , ;

\prof [memman-init] end-bucket
