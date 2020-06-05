\ *** Block No. 126, Hexblock 7e

\ shell loadscreen             21sep94pz

  cr .( module shell ) cr


\ *** Block No. 127, Hexblock 7f

\   shell:                     21sep94pz

Code bye   $37 # lda  $1 sta
           $a000 ) jmp  end-code

' savesystem        alias saveall
' .mem              alias mem
' himem!            alias set-himem
' #links!           alias set-heap
' #globals!         alias set-hash
' symtabsize!       alias set-symtab
' codesize!         alias set-code
' relocate          alias set-stacks

: auxdev ( n -- )             aux# c! ;
: device ( n -- ) dup dev# c! aux# c! ;
: device?  ( -- )
 ." actual device number is " dev . cr
 ." auxiliar dev. number is " aux . ;

\ : delay  ( n -- )  fdelay ! ;
\ : delay? ( -- )
\    ." delay after fopen/fclose is" cr
\    fdelay @ u. ." /60 seconds." cr ;


\ *** Block No. 128, Hexblock 80

\   shell:                     09sep94pz

: dir  ( -- )
   dev 0 busopen  ascii $ bus! busoff
   dev 0 busin bus@ bus@ 2drop
   BEGIN cr bus@ bus@ 2drop
   i/o-status? 0= WHILE
   bus@ bus@ lo/hi> u.
   BEGIN bus@ ?dup WHILE con! REPEAT
   REPEAT busoff  dev 0 busclose ;

: dos  ( -- )
   bl word count ?dup
      IF dev 15 busout bustype
      busoff cr ELSE drop THEN
   dev 15 busin
   BEGIN bus@ con! i/o-status? UNTIL
   busoff ;

: cat   ( -- ) cr
   dev 2 busopen  bl word count bustype
   busoff  dev 2 busin  BEGIN bus@ con!
   i/o-status? UNTIL busoff
   dev 2 busclose ;


\ *** Block No. 129, Hexblock 81

\   shell: cold' logo          01mar20pz

| Code charset  here 6 + jsr xyNext jmp
                 $cbfa ) jmp end-code

| : init-shell  ( -- )
     only shell
     $cbfc 2@  $65021103. d=
        IF charset THEN ;

' init-shell IS 'cold


| : .logo  ( -- )
     ."     running" cr
     ." cc64 C compiler V0.6" cr
     ." 2020 by Philip Zembrod" cr
     $cbfc 2@  $65021103. d= not ?exit
     ." C charset in use" cr ;

' .logo IS 'restart


\ *** Block No. 130, Hexblock 82

\   shell                      20sep94pz

: help  ." available commands:" cr
        words ;

' cc                alias cc
