
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen" cc64-test.log"

| ' |     alias ~
| ' |on   alias ~on
| ' |off  alias ~off

  include notmpheap.fth

  onlyforth  decimal  cr
  include util-words.fth  \ unloop strcmp doer-make
  cr
  | : 2@  ( adr -- d)  dup 2+ @ swap @ ;
  | : 2!  ( d adr --)  under !  2+ ! ;
  \ include 2words.fth  \ 2@ 2!
  cr
  vocabulary compiler
  compiler also definitions

  include init.fth

  include strtab.fth
  include errormsgs.fth
  include errorhandler.fth

  31 constant /id
  6 constant /link   \ listenknoten
  4 constant /symbol \ datenfeldgroesse

  10  constant #links
  6   constant #globals
  100 constant symtabsize

  create heap[ #links /link * allot  here constant ]heap
  create hash[ #globals 2+ allot  here constant ]hash
  create symtab[ symtabsize allot  here constant ]symtab

  variable eof
  -1 constant #eof
  variable comment-state
  variable line
  variable comment-line

  : char> ;
  : +char ;
  : newline ;

  include scanner.fth
  include symboltable.fth
  \ include preprocessor.fth
  \ make preprocess ;

  include listman.fth

  variable >pc
  : pc  >pc @ ;
  include fake-v-asm.fth

~ variable tos-offs

~ : dyn-allot ( n -- offs )
     tos-offs @  swap tos-offs +! ;

  include codegen.fth
|| variable static>

~ : staticadr> ( -- current.adress )
     static> @ ;

~ : >staticadr ( adr -- )
     static>  ! ;
  : stat, ." stat, " . ;
  : cstat, ." cstat, " . ;

  : flushcode ;
  : flushstatic ;

  include parser.fth

: dos  ( -- )
   bl word count ?dup
      IF 8 15 busout bustype
      busoff cr ELSE drop THEN
   8 15 busin
   BEGIN bus@ con! i/o-status? UNTIL
   busoff ;

  .( test successful) cr

\log logclose
