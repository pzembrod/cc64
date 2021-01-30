
\ fake for codehandler.fth

  variable >pc
  : pc  >pc @ ;

  variable tos-offs

  : dyn-allot ( n -- offs )
     tos-offs @  swap tos-offs +! ;

  variable static>

  : staticadr> ( -- current.adress )
     static> @ ;

  : >staticadr ( adr -- )
     static>  ! ;
  : stat, ." stat, " . ;
  : cstat, ." cstat, " . ;

  : flushcode ;
  : flushstatic ;

