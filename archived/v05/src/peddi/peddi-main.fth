
  onlyforth  decimal

\ 3 drive  \ 5 load

\ *** Block No. 5, Hexblock 5

\ peddi loadscreen standalone  07may95pz

| vocabulary peddi
  vocabulary shell
  peddi also definitions

|  create dev#  8 c,
| : dev  dev# c@ ;

| : text[   r0 @ ;
| ' limit ALIAS ]text

  include ed-func.fth  \ 18 load   \ editor functions
  include ed-frame.fth  \ 12 load   \ editor framework

  shell also definitions

' ed ALIAS ed

' bye ALIAS bye

  include peddi-shell.fth  \ 7 10 thru  \ shell & savesystem
  \ 2 load     \ set memory
  save

| : relocate-tasks  ( newUP -- )
 up@ dup BEGIN  1+ under @ 2dup -
 WHILE  rot drop  REPEAT  2drop ! ;

| : relocate  ( stacklen rstacklen -- )
 empty  256 max 8192 min  swap
 256 max 8192 min  pad + 256 +
 2dup + 2+ limit u>
 abort" stacks beyond limit"
 under  +   origin $A + !        \ r0
 dup relocate-tasks
 up@ 1+ @   origin   1+ !        \ task
       6 -  origin  8 + ! cold ; \ s0

  $cbd0 ' limit >body !
  0 ink-pot !  15 ink-pot 2+ c!
  256 256 relocate
