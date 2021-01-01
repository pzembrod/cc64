
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen" cc64pe.log"

| ' |     alias ~
| ' |on   alias ~on
| ' |off  alias ~off

  (64 include tmpheap.fth C)
  (64 $2000 mk-tmp-heap C)
  (16 include notmpheap.fth C)
  (CX include x16tmpheap.fth C)

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
  (64 include tmp6502asm.fth  C)  \ 6502 assembler on tmpheap
  (16 include trns6502asm.fth  C) \ 6502 assembler on heap
  (CX include tmp6502asm.fth  C)  \ 6502 assembler on tmpheap
  include lowlevel.fth
  onlyforth compiler also definitions
  include v-assembler.fth
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
  | : .binary-name  ." cc64pe C compiler + peddi editor" ;
  include init-shell.fth

  onlyforth

  ' noop is .status

  (64 0 ink-pot !  15  ink-pot 2+ c! C)
  (16 0 ink-pot !  125 ink-pot 2+ c! C)

  save

\ peddi loadscreen for cc64    19apr20pz

  onlyforth  decimal
| vocabulary peddi
  compiler also peddi also definitions

| ' lomem    alias text[
| ' himem    alias ]text
| ' dev      alias dev

  onlyforth peddi also definitions

  include ed-func.fth   \ editor functions
  include ed-frame.fth  \ editor framework

  shell also definitions

' ed ALIAS ed

  save
  cr .( compile successful) cr

\log logclose

  (64 $cbd0 set-himem C)
  (16 $f000 set-himem C)
  (64 2000 set-symtab C)
  1024 1024 set-stacks
