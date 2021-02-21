
\ with build log:
\ ' noop alias \log
\ without build log:
' \ alias \log

\log include logtofile.fth
\log logopen" timertest.log"

| ' noop     alias ~
| ' |on   alias ~on
| ' |off  alias ~off

  include notmpheap.fth

  onlyforth  decimal
  \ | : include  include base push hex cr here u. heap u. up@ u. ;

  include util-words.fth

Onlyforth  Assembler also definitions
  include 6502asm.fth
Onlyforth
  include lowlevel.fth
  include 6526timer.fth
  include profiler.fth

  : test1 reset-32bit-timer ;
  : test2 begin read-32bit-timer cr d. key? until ;

  : test3 reset-50ms-timer ;
  : test4 begin read-50ms-timer cr dup u. ms. key? until ;

\log logclose
