
  variable next-dump
  : dump ( adr -- ) base push hex
     dup u. 8 bounds over next-dump ! DO I c@ u. LOOP ;
  : +d  next-dump @ dump ;
