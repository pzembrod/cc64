\ *** Block No. 126, Hexblock 7e

\ shell loadscreen             21sep94pz

\ *** Block No. 127, Hexblock 7f

\   shell:                     21sep94pz

\ Code bye
\ (64  $37 # lda  $1 sta  $a000 ) jmp  C)
\ (16  $fff6 jmp  C)
\ end-code
' bye alias bye

' savesystem         alias saveall
' .mem               alias mem
' himem!             alias set-himem
' #links!            alias set-heap
' #globals!          alias set-hash
' symtabsize!        alias set-symtab
(CX \ C) ' codesize! alias set-code
' relocate           alias set-stacks

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

\log : logfile  logopen alsologtofile ;

\log : logclose  display logclose ;

: list!  ( flag -- )  listing ! ;
: list?  ( -- )  listing @ . ;

\ *** Block No. 130, Hexblock 82

\   shell                      20sep94pz

: help  ." available commands:" cr
        words ;

' cc                alias cc
(CX ' xed           alias xed C)
