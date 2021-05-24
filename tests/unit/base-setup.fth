
\needs \prof  ' \ alias \prof immediate

  ' noop   alias ~
  ' noop  alias ~on
  ' noop  alias ~off

  include tmpheap.fth
  $2000 mk-tmp-heap

  : dos  ( -- )
   bl word count ?dup
      IF 8 15 busout bustype
      busoff cr ELSE drop THEN
   8 15 busin
   BEGIN bus@ con! i/o-status? UNTIL
   busoff ;

  onlyforth  decimal
  include util-words.fth
  include tmp6502asm.fth
  include strings.fth

  include tester.fth
  decimal

  cr
  vocabulary compiler
  compiler also definitions

  include init.fth

  include strtab.fth
  include errormsgs.fth
  include fake-err-hdl.fth
  tmp-clear
