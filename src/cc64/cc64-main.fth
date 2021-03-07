
\ with build log:
' noop alias \log
\ without build log:
\ ' \ alias \log

\log include logtofile.fth
\log logopen cc64.log

\ with profiling, only on C64:
| ' \ (64 drop ' noop C) alias \prof
\ without profiling:
\ | ' \ alias \prof

\prof ' \ alias \prof1

| ' |     alias ~
| ' |on   alias ~on
| ' |off  alias ~off

  (64 include tmpheap.fth C)
  (64 $2000 mk-tmp-heap C)
  (16 include notmpheap.fth C)
  (CX include x16tmpheap.fth C)

  onlyforth  decimal
  \ | : include  include base push hex cr here u. heap u. up@ u. ;

  include util-words.fth
  \prof include tmp6502asm.fth
  \prof include 6526timer.fth
  \prof include profiler.fth
  \prof profiler-init-buckets
~ vocabulary compiler
  compiler also definitions

  \prof1 profiler-bucket-begin" memory"
  include init.fth

  include strtab.fth
  include errormsgs.fth
  include errorhandler.fth
  include memman.fth
  tmpclear

  \prof1 profiler-bucket-begin" files"
  include fileio.fth
  include fileman.fth
  tmpclear

  include codehandler.fth
  tmpclear
  include rt-ptrs.fth

  \prof1 profiler-bucket-begin" input"
  include input.fth
  \prof1 profiler-bucket-begin" scanner"
  include scanner.fth
  \prof1 profiler-bucket-begin" symtab"
  include symboltable.fth
  include preprocessor.fth
  tmpclear

  \prof1 profiler-bucket-begin" parser"
  include listman.fth
  tmpclear

  onlyforth
  (64 include tmp6502asm.fth  C)  \ 6502 assembler on tmpheap
  (16 include trns6502asm.fth  C) \ 6502 assembler on heap
  (CX include tmp6502asm.fth  C)  \ 6502 assembler on tmpheap
  include lowlevel.fth
  (CX include x16edit.fth  C)
  onlyforth compiler also definitions
  include v-assembler.fth
  include codegen.fth
  include parser.fth
  \prof1 profiler-bucket-begin" pass2"
  include p2write-decl.fth
  tmpclear

  include pass2.fth
  include invoke.fth

  \prof1 profiler-bucket-begin" shell"
  forth definitions
  include savesystem.fth

  onlyforth
  vocabulary shell
  compiler also  shell definitions

  include shell.fth
  include version.fth
  | : .binary-name  ." cc64 C compiler" ;
  include init-shell.fth

  \prof include prof-scan1.fth

  onlyforth

  ' noop is .status

  (64 0 ink-pot !  15  ink-pot 2+ c! C)
  (16 0 ink-pot !  125 ink-pot 2+ c! C)

  cr
  .( here/heap/up@ = )
  base @  hex here u. heap u. up@ u. cr  base !
  s0 @ here - u. .( dictionary bytes to spare pre save ) cr
\log display
  save
\log alsologtofile
  s0 @ here - u. .( dictionary bytes to spare post save ) cr
  .( here/heap/up@ = )
  base @  hex here u. heap u. up@ u. cr  base !

  cr .( compile successful) cr

\log logclose

  shell
  (64 $cbd0 set-himem C)
  (16 $f000 set-himem C)
  512 512 set-stacks
