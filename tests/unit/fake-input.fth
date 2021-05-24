
\ fake for input.fth

  variable eof
  -1 constant #eof
  variable comment-state
  variable line
  variable comment-line

  variable inptr
  variable lineptr

  variable last-src

  : +char  ( -- )  1 inptr +! ;
  : char>  ( -- c )  inptr @ c@ ;

  : src-begin  create   last @ dup , name> last-src !
      does> dup @ count type cr 2+
      dup lineptr !  1+ inptr !    1 line !
      eof off  comment-state off  init ;

  : src@  ascii @ parse
     here over 1+  allot place  0 c, ;

  : src-end  0 c, ;

  : nextline  lineptr @ count + 1+  dup lineptr !
      dup c@ IF 1+ ELSE #eof eof ! THEN inptr ! ;

  : printsourceline  ( -- )
     lineptr @ 80 bounds
     DO I c@ ?dup 0= IF LEAVE THEN
     emit LOOP cr ;

make printcontext  ( -- )
      eof @ #eof = ?exit
      printsourceline
      inptr @ lineptr @ - 1- 0 max
      spaces ASCII ^ emit  cr ;
