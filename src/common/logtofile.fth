
create log-dev  8 c,
create log-2nd  9 c,
: log-dev-2nd@ log-dev c@ log-2nd c@ ;

: log-emit
  dup c64emit log-dev-2nd@ busout bus! busoff ;

: log-cr
  c64cr log-dev-2nd@ busout #cr bus! busoff ;

: log-type
  2dup c64type log-dev-2nd@ busout bustype busoff ;

Output: alsologtofile
 log-emit log-cr log-type c64del c64page
 c64at c64at? ;

: logopen
  bl parse  2dup type
  log-dev-2nd@ busopen
  bustype " ,s,w" count bustype busoff
  i/o-status? IF c64cr log-dev c@ dos-error abort THEN
  alsologtofile ;

: logclose
  cr  display  log-dev-2nd@ busclose ;
