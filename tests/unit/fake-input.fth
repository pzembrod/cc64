
\ fake for input.fth

  variable eof
  -1 constant #eof
  variable comment-state
  variable line
  variable comment-line

  variable inptr
  variable lineptr

  : +char  ( -- )  1 inptr +! ;
  : char>  ( -- c )  inptr @ c@ ;

  : src-begin  create
      does> dup lineptr !  1+ inptr !    1 line !
      eof off  comment-state off ;
  : src@  ascii @ parse
     here over 1+  allot place  0 c, ;

  : src-end  0 c, ;
  : nextline  lineptr @ count + 1+  dup lineptr !
      dup c@ IF 1+ ELSE #eof eof ! THEN inptr ! ;
