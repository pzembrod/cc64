
  onlyforth  decimal  cr
  | ' include alias forth-include

| : ~  | ;

  forth-include util-words.fth  \ unloop strcmp doer-make
  cr
  forth-include trns6502asm.fth  \ transient 6502 assembler
  forth-include 2words.fth  \ 2@ 2! 2variable/constant
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

  onlyforth

  ' noop is .status

  0 ink-pot !  15 ink-pot 2+ c!

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

| : .logo  ( -- )
   [ ' 'restart >body @ , ]
   ." peddi text editor present"
   cr ;

' .logo IS 'restart

  save
  $cbd0 set-himem
  2000 set-symtab
  1024 1024 set-stacks
