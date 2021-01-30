
\ fake for input.fth

  variable eof
  -1 constant #eof
  variable comment-state
  variable line
  variable comment-line

  : char> ;
  : +char ;
  : newline ;
