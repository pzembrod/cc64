
\ fake for codehandler.fth

   variable >tos-offs

~ : dyn-offs  ( -- offs )  >tos-offs @ ;

~ : dyn-reset  ( -- )  >tos-offs off ;

~ : dyn-allot ( n -- offs )
     dyn-offs  swap >tos-offs +! ;

  variable statics.last

  variable staticadr

  : staticadr> ( -- current.adress )
     staticadr @ ;

  : >staticadr ( adr -- )
     staticadr  ! ;

  : init-static  $a000 dup >staticadr  statics.last ! ;
  init: init-static

  : stat,   . ." stat, "   -2 staticadr +! ;
  : cstat,  . ." cstat, "  -1 staticadr +! ;

  : flushcode ;
  : flushstatic ;

