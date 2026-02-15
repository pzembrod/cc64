
\needs \log  ' \ alias \log immediate
\needs \prof  | ' \ alias \prof immediate
\needs \6526  | ' \ alias \6526 immediate
\needs \time  | ' \ alias \time immediate

| ' |     alias ~
| ' |on   alias ~on
| ' |off  alias ~off

  (64 include trnstmpheap.fth C)
  (64 $1e80 mk-tmp-heap C)
  (16 include notmpheap.fth C)
  (CX include x16trnstmphp.fth C)

  onlyforth  decimal
  \ | : include  include base push hex cr here u. heap u. up@ u. ;

  include util-words.fth
  (64  include tmp6502asm.fth C)  \ 6502 assembler on tmpheap
  (16 include trns6502asm.fth  C) \ 6502 assembler on heap
  (CX  include tmp6502asm.fth C)  \ 6502 assembler on tmpheap
  include lowlevel.fth
  \6526 include 6526timer.fth
  \prof \needs deltaTime include faketimer.fth
  \prof \time include mock32timer.fth
  \prof include profiler.fth
  \prof profiler-init-buckets
  \prof profiler-bucket [strings]
  include strings.fth
  \prof [strings] end-bucket
~ vocabulary compiler
  compiler also definitions

  (CX include x16edit.fth  C)

  \prof profiler-bucket [memman-etc]
  include init.fth

  include strtab.fth
  include errormsgs.fth
  include errorhandler.fth
  include memman.fth
  tmp-clear
  \prof [memman-etc] end-bucket

  \prof profiler-bucket [file-handling]
  include fileio.fth
  include fileman.fth
  tmp-clear

  include codehandler.fth
  tmp-clear
  include rt-ptrs.fth
  \prof [file-handling] end-bucket

  \prof profiler-bucket [input]
  include input.fth
  \prof [input] end-bucket
  \prof profiler-bucket [scanner]
  include scanner.fth
  \prof [scanner] end-bucket
  \prof profiler-bucket [symtab-etc]
  include symboltable.fth
  include preprocessor.fth
  tmp-clear
  \prof [symtab-etc] end-bucket

  \prof profiler-bucket [parser]
  include listman.fth
  tmp-clear

  onlyforth
  (64 include tmp6502asm.fth  C)  \ 6502 assembler on tmpheap
  (CX include tmp6502asm.fth  C)  \ 6502 assembler on tmpheap
  onlyforth compiler also definitions
  include v-assembler.fth
  include codegen.fth
  include parser.fth
  \prof [parser] end-bucket

  \prof profiler-bucket [minilinker]
  include write-decl.fth
  tmp-clear

  \ From here on everything can go onto
  \ the tmpheap, interface or not,
  \ because the next tmp-clear comes
  \ directly before the save.
  \ Else on the X16 dictionary space
  \ becomes tight.
  || ' || alias ~

  include minilinker.fth
  include invoke.fth
  \prof [minilinker] end-bucket

  forth definitions
  include savesystem.fth

  onlyforth
  vocabulary shell
  compiler also  shell definitions

  \prof profiler-bucket [shell]
  include shell.fth
  include version.fth
  | : .binary-name  ." cc64 C compiler" ;
  include init-shell.fth
  \prof [shell] end-bucket

  \prof include prof-metrics.fth

  onlyforth

  ' noop is .status

  (64 0 ink-pot !  15  ink-pot 2+ c! C)
  (16 0 ink-pot !  125 ink-pot 2+ c! C)

  cr
  .( here/heap/up@ = )
  base @  hex here u. heap u. up@ u. cr  base !
  s0 @ here - u. .( dictionary bytes to spare pre save ) cr
  tmp-clear
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
