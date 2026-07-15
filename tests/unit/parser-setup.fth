
  include fake-memheap.fth
  include listman.fth
  tmp-clear

  include fake-codeh.fth
  include fake-v-asm.fth

  include codegen.fth

  include notmpheap.fth

  include parser.fth

  : fetchglobal"  ascii " word findglobal IF 2@ THEN ;
  : fetchlocal"  ascii " word findlocal IF 2@ THEN ;
