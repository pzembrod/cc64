
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

: device  ( n -- )
  dev# c! ;

: device?  ( -- )
  ." actual device number is "
  dev# c@ . ;

: help  ( -- )
  ." available commands:" cr words ;

' savesystem        alias saveall
