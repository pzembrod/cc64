
\ with build log:
' noop alias \log
\ without build log:
\ alias \log

\log include logtofile.fth
\log logopen" profilertest.log"

  ' noop   alias ~
  ' noop  alias ~on
  ' noop  alias ~off

  include notmpheap.fth

  : dos  ( -- )
   bl word count ?dup
      IF 8 15 busout bustype
      busoff cr ELSE drop THEN
   8 15 busin
   BEGIN bus@ con! i/o-status? UNTIL
   busoff ;

  include tester.fth

  onlyforth  decimal

  include util-words.fth

Onlyforth  Assembler also definitions
  include 6502asm.fth
Onlyforth
  include lowlevel.fth

  \ include 6526timer.fth

  assembler also definitions
  variable ip
  create CIA 16 allot
  CIA 4 + constant timerAlo
  CIA 5 + constant timerAhi
  CIA 6 + constant timerBlo
  CIA 7 + constant timerBhi
  CIA $e + constant timerActrl
  CIA $f + constant timerBctrl
  onlyforth 

  include profiler.fth

  Code callFindBucket ( -- )  findBucket  0 # ldx Next jmp end-code
  
  assembler also
  
  : testFindBucket ( addr -- x )
     ip !  $ff currentBucket c!  callFindBucket  currentBucket c@ ;

  (profiler-init
  variable b-1
  profiler-bucket
  variable b0
  profiler-bucket
  variable b1
  profiler-bucket
  variable b2
  profiler-bucket
  variable b3
  profiler-bucket
  variable b4
  profiler-bucket
  variable b5
  profiler-bucket
  variable b6
  profiler-bucket
  variable b7

  decimal

  T{ ' dup testFindBucket -> $ff }T
  T{ b-1 testFindBucket -> 0 }T
  T{ b0 testFindBucket -> 4 }T
  T{ b1 testFindBucket -> 8 }T
  T{ b2 testFindBucket -> 12 }T
  T{ b3 testFindBucket -> 16 }T
  T{ b4 testFindBucket -> 20 }T
  T{ b5 testFindBucket -> 24 }T
  T{ b6 testFindBucket -> 28 }T
  T{ b7 testFindBucket -> 32 }T

  code callCalcTime  calcTime  Next jmp end-code
  $dddd timerBlo !
  $cccc timerAlo !
  $eeeeeeee. prevTime 2!
  T{ callCalcTime  deltaTime 2@ -> $11112222. }T

  code callSetPrevTime  setPrevTime  Next jmp end-code
  $1234 timerBlo !
  $abcd timerAlo !
  T{ callSetPrevTime  prevTime 2@ -> $1234abcd. }T

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
