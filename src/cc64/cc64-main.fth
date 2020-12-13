
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen" cc64.log"

  \ include tmpheap.fth
  \ $600 mk-tmp-heap
  | ' | alias ||
  | ' noop alias tmpclear

  onlyforth  decimal  cr
  | ' include alias forth-include
  \ | : forth-include  include
  \    base push hex cr here u. heap u. up@ u. ;

| ' |     alias ~
| ' |on   alias ~on
| ' |off  alias ~off

  forth-include util-words.fth  \ unloop strcmp doer-make
  cr
  forth-include trns6502asm.fth  \ transient 6502 assembler
  forth-include 2words.fth  \ 2@ 2!
  cr
  vocabulary compiler
  compiler also definitions

  forth-include strtab.fth
  forth-include init.fth
  forth-include errormsgs.fth
  forth-include errorhandler.fth
  forth-include memman.fth
  forth-include listman.fth
  forth-include fileio.fth
  forth-include fileman.fth
  forth-include input.fth
  forth-include scanner.fth
  forth-include symboltable.fth
  forth-include codehandler.fth
  forth-include codeoutput.fth
  forth-include v-assembler.fth
  forth-include preprocessor.fth

  forth-include codegen.fth
  forth-include parser.fth
  forth-include pass2.fth
  forth-include invoke.fth

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

  save
  cr .( compile successful) cr

\log logclose

  shell
  (64 $cbd0 set-himem C)
  (16 $f000 set-himem C)
  1024 1024 set-stacks
