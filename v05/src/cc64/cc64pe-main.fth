
  onlyforth  decimal  cr
  | ' include alias forth-include

| : ~  | ;

 1 drive

  forth-include util-words.fth  \ 6 8 thru   \ unloop strcmp doer-make
  cr
  forth-include trns6502asm.fth  \ 120 load    \ transient assembler
  forth-include 2words.fth  \ 129 load    \ 2@ 2! 2variable/constant
  cr
  vocabulary compiler
  compiler also definitions
  \ 9 10 thru  \ strtab init
  forth-include strtab.fth
  forth-include init.fth
  forth-include errormsgs.fth  \ 24 load    \ errormessages
  forth-include errorhandler.fth  \ 54 load    \ errorhandler
  forth-include memman.fth  \ 12 load    \ memman
  forth-include listman.fth  \ 18 load    \ listman
  forth-include fileio.fth  \ 112 load    \ fileio
  forth-include fileman.fth  \ 78 load    \ fileman
  forth-include input.fth  \ 30 load    \ input
  forth-include scanner.fth  \ 36 load    \ scanner
  60 load    \ symboltable
  72 load    \ codehandler
  77 load    \ codeoutput
  forth-include vassembler.fth  \ 84 load    \ assembler

  \ 104 load    \ preprocessor
  forth-include preprocessor.fth

  \ 2 drive

   \ 12 load \     codegen
  forth-include codegen.fth

  \ 48 load \     parser
  forth-include parser.fth

  \ 108 load \     pass2
  forth-include pass2.fth

  \ 100 load \     invoke
  forth-include invoke.fth

  \ \needs doesn't work yet with text file sources
  \ needs savesysdev  | defer savesysdev
  ' dev IS savesysdev

  onlyforth
  \ 8 load \     savesystem
  \ needs savesystem  forth-include savesystem.fth

  vocabulary shell
  compiler also  shell definitions

  \ 126 load \     shell
  forth-include shell.fth

  onlyforth

  ' noop is .status

  0 ink-pot !  15 ink-pot 2+ c!

  save

 3 drive

 4 load \ peddi

  save
  $cbd0 set-himem
  2000 set-symtab
  $c000 ' limit >body !
  1024 1024 set-stacks
