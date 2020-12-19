
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen" cc64.log"

| ' |     alias ~
| ' |on   alias ~on
| ' |off  alias ~off

  include tmpheap.fth

  (64 $2000 mk-tmp-heap C)
  (16 $e00 mk-tmp-heap C)
  (CX 1 $9f61 c!  $a000 tmpheap[ !  $c000 dup ]tmpheap ! tmpheap> ! C)

  \ | ' | alias ||
  \ | ' noop alias tmpclear

  onlyforth  decimal  cr
  | ' include alias forth-include
  \ | : forth-include  include
  \    base push hex cr here u. heap u. up@ u. ;

  forth-include util-words.fth  \ unloop strcmp doer-make
  cr
  | : 2@  ( adr -- d)  dup 2+ @ swap @ ;
  | : 2!  ( d adr --)  under !  2+ ! ;
  \ forth-include 2words.fth  \ 2@ 2!
  cr
  vocabulary compiler
  compiler also definitions

  forth-include init.fth

  forth-include strtab.fth
  forth-include errormsgs.fth
  forth-include errorhandler.fth
  forth-include memman.fth
  tmpclear

  forth-include fileio.fth
  forth-include fileman.fth
  tmpclear

  forth-include codehandler.fth
  tmpclear
  forth-include rt-ptrs.fth

  forth-include input.fth
  forth-include preprocessor.fth
  include scanner.fth
  forth-include symboltable.fth
  tmpclear

  forth-include listman.fth
  tmpclear

  onlyforth
  forth-include tmp6502asm.fth  \ transient 6502 assembler
  onlyforth compiler also definitions
  \ forth-include v-assembler.fth
  forth-include v-asm2.fth
  forth-include lowlevel.fth
  \ tmpclear

  forth-include codegen2.fth
  forth-include parser.fth
  forth-include p2write-decl.fth
  tmpclear
  forth-include pass2.fth
  forth-include invoke.fth
  words

  forth definitions
  forth-include savesystem.fth

  onlyforth
  vocabulary shell
  compiler also  shell definitions

  forth-include shell.fth
  forth-include version.fth
  | : .binary-name  ." cc64 C compiler" ;
  forth-include init-shell.fth

  onlyforth

  ' noop is .status

  (64 0 ink-pot !  15  ink-pot 2+ c! C)
  (16 0 ink-pot !  125 ink-pot 2+ c! C)

  base @  hex here u. heap u. up@ u.  base !
  save
  cr .( compile successful) cr

\log logclose

  shell
  (64 $cbd0 set-himem C)
  (16 $f000 set-himem C)
  1024 1024 set-stacks
