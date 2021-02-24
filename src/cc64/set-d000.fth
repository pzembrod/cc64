
: relocate-tasks  ( newUP -- )
 up@ dup BEGIN  1+ under @ 2dup -
 WHILE  rot drop  REPEAT  2drop ! ;

: abs-relocate  ( s0 r0/limit -- )
 dup ['] limit >body !
 origin $A + !        \ r0
 dup relocate-tasks
 up@ 1+ @   origin   1+ !        \ task
       6 -  origin  8 + ! cold ; \ s0

$cc00 $d000 abs-relocate
