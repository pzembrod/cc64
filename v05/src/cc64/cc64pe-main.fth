
  onlyforth  decimal  cr
  | ' include alias forth-include

| : ~  | ;

 1 drive

  6 8 thru   \ unloop strcmp doer-make
 120 load    \ transient assembler
 129 load    \ 2@ 2! 2variable/constant
  vocabulary compiler
  compiler also definitions
  9 10 thru  \ strtab init
  24 load    \ errormessages
  54 load    \ errorhandler
  12 load    \ memman
  18 load    \ listman
 112 load    \ fileio
  78 load    \ fileman
  30 load    \ input
  36 load    \ scanner
  60 load    \ symboltable
  72 load    \ codehandler
  77 load    \ codeoutput
  84 load    \ assembler
 104 load    \ preprocessor

 2 drive

   \ 12 load \     codegen
  forth-include codegen.fth

  \ 48 load \     parser
  forth-include parser.fth

  \ 108 load \     pass2
  forth-include pass2.fth

  100 load \     invoke
    8 load \     savesystem

  onlyforth
  vocabulary shell
  compiler also  shell definitions

  126 load \     shell

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
