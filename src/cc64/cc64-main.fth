
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
  (16 $2000 mk-tmp-heap C)
  (CX 1 $9f61 c!  $a000 tmpheap[ !  $c000 dup ]tmpheap ! tmpheap> ! C)

  \ | ' | alias ||
  \ | ' noop alias tmpclear

  onlyforth  decimal  cr
  \ | : include  include base push hex cr here u. heap u. up@ u. ;

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
  include memman.fth
  tmpclear

  include fileio.fth
  include fileman.fth
  tmpclear

  include codehandler.fth
  tmpclear
  include rt-ptrs.fth

  include input.fth
  include scanner.fth
  include symboltable.fth
  include preprocessor.fth
  tmpclear

  include listman.fth
  tmpclear

  onlyforth
  include tmp6502asm.fth  \ transient 6502 assembler
  onlyforth compiler also definitions
  include v-assembler.fth
  include lowlevel.fth
  \ tmpclear

  include codegen.fth
  include parser.fth
  include p2write-decl.fth
  tmpclear
  include pass2.fth
  include invoke.fth
  \ words

  forth definitions
  include savesystem.fth

  onlyforth
  vocabulary shell
  compiler also  shell definitions

  include shell.fth
  include version.fth
  | : .binary-name  ." cc64 C compiler" ;
  include init-shell.fth

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
