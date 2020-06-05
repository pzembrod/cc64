\ *** Block No. 7, Hexblock 7

\   shell: cold' logo          14apr20pz

| create charset    here here 2- !
   also assembler   here 6 +  $20 c, ,
   xyNext $4c c, ,  $cbfa     $6c c, ,
   toss

\ needs 2@  | : 2@  dup 2+ @ swap @ ;
| : 2@  dup 2+ @ swap @ ;

| : init-shell  ( -- )
     only shell
     $cbfc 2@  $65021103. d=
        IF charset THEN ;

' init-shell IS 'cold

| : .logo  ( -- )
     ."     running" cr
     ." peddi text editor V0.6" cr
     ." 1995 by Philip Zembrod" cr
     $cbfc 2@  $65021103. d= not ?exit
     ." C charset in use" cr ;

' .logo IS 'restart


\ *** Block No. 8, Hexblock 8

\   shell:                     03sep94pz

: dir  ( -- )
   dev 0 busopen  ascii $ bus! busoff
   dev 0 busin bus@ bus@ 2drop
   BEGIN cr bus@ bus@ 2drop
   i/o-status? 0= WHILE
   bus@ bus@ 256 * + u.
   BEGIN bus@ ?dup WHILE con! REPEAT
   REPEAT busoff dev 0 busclose ;

: dos  ( -- )
   bl word count ?dup
      IF  dev 15 busout  bustype
      busoff  cr ELSE drop THEN
   dev 15 busin
   BEGIN bus@ con! i/o-status? UNTIL
   busoff ;

: cat    ( -- )  cr
   dev 2 busopen  bl word count bustype
   busoff  dev 2 busin  BEGIN bus@ con!
   i/o-status? UNTIL busoff
   dev 2 busclose ;


\ *** Block No. 9, Hexblock 9

\   shell: cold' logo          14apr20pz

  : device  ( n -- )
     dev# c! ;

  : device?  ( -- )
     ." actual device number is "
     dev# c@ . ;

  : help  ( -- )
     ." available commands:" cr words ;


\ *** Block No. 10, Hexblock a

\ savesystem                   17apr20pz

' dev IS savesysdev

' savesystem        alias saveall
