
  onlyforth  decimal

\ peddi loadscreen standalone  07may95pz

  include trns6502asm.fth  \ transient 6502 assembler

| vocabulary peddi
  vocabulary shell
  peddi also definitions

|  create dev#  8 c,
| : dev  dev# c@ ;

| : text[   r0 @ ;
| ' limit ALIAS ]text

  include ed-func.fth   \ editor functions
  include ed-frame.fth  \ editor framework

  forth definitions
  |  ' | alias ~
  include savesystem.fth

  shell also definitions

' ed ALIAS ed

' bye ALIAS bye

  include peddi-shell.fth  \ shell & savesystem
  include version.fth
  | : .binary-name  ." peddi text editor" ;
  | : 2@  dup 2+ @ swap @ ;
  include init-shell.fth

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
  (64 0 ink-pot !  15  ink-pot 2+ c! C)
  (16 0 ink-pot !  125 ink-pot 2+ c! C)
  256 256 relocate
