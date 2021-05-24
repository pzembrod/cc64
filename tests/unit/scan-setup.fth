
  include fake-memsym.fth
  include symboltable.fth
  : globals-empty?  globals> @ symtab[ = ;
  : locals-empty?   locals> @ 1+ ]symtab = ;
  tmp-clear

  include fake-input.fth
  include scanner.fth
  ' id-buf alias scn-idbuf
  tmp-clear

  : test-begin
     src-end  last-src perform  fetchword ;

  : test-end
     T{ thisword -> #eof# }T
     check-error-messages ;
