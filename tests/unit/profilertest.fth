
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

  onlyforth assembler also definitions
  include 6502asm.fth

  onlyforth assembler also definitions
  variable ip
  create CIA 16 allot
  CIA 4 + constant timerAlo
  CIA 5 + constant timerAhi
  CIA 6 + constant timerBlo
  CIA 7 + constant timerBhi
  CIA $e + constant timerActrl
  CIA $f + constant timerBctrl
  onlyforth
  : reset-32bit-timer ;

  include profiler.fth

  : .blk|tib
     blk @ ?dup IF  ."  Blk " u. ?cr  exit THEN
     factive? IF tib #tib @ cr type THEN ;

  \ ' .blk|tib Is .status

  Code callFindBucket ( -- )  findBucket  0 # ldx Next jmp end-code
  
  assembler also
  
  : testFindBucket ( addr -- x )
     ip !  $ff currentBucket c!  callFindBucket  currentBucket c@ ;

  profiler-init-buckets
  variable bucket-1
  profiler-bucket-begin" bucket 1"
  variable bucket0
  profiler-bucket-begin" bucket 2"
  variable bucket1
  profiler-bucket-begin" bucket 3"
  variable bucket2
  profiler-bucket-begin" bucket 4"
  variable bucket3
  profiler-bucket-begin" bucket 5"
  variable bucket4
  profiler-bucket-begin" bucket 6"
  variable bucket5
  profiler-bucket-begin" bucket 7"
  variable bucket6

  hex

  T{ ' dup testFindBucket -> $ff }T
  T{ bucket-1 testFindBucket -> 0 }T
  T{ bucket0 testFindBucket -> $4 }T
  T{ bucket1 testFindBucket -> $8 }T
  T{ bucket2 testFindBucket -> $c }T
  T{ bucket3 testFindBucket -> $10 }T
  T{ bucket4 testFindBucket -> $14 }T
  T{ bucket5 testFindBucket -> $18 }T
  T{ bucket6 testFindBucket -> $1c }T

  code callCalcTime  calcTime  Next jmp end-code
  $dddd timerBlo !
  $cccc timerAlo !
  $eeeeeeee. prevTime 2!
  T{ callCalcTime  deltaTime 2@ -> $11112222. }T

  code callSetPrevTime  setPrevTime  Next jmp end-code
  $1234 timerBlo !
  $abcd timerAlo !
  T{ callSetPrevTime  prevTime 2@ -> $1234abcd. }T

  : fetch-dwords  ( addr n -- d0 d1 ... dn-1 )
      2* 2* bounds ?DO I 2@ 4 +LOOP ;

  code callAddTimeToBucket ( x -- )
    sp X) lda  tax  addTimeToBucket  0 # ldx  Pop jmp end-code
  bucketTimes $24 erase
  T{ bucketTimes 9 fetch-dwords
      -> 0. 0. 0. 0. 0. 0. 0. 0. 0. }T
  $12345678. deltaTime 2!
  T{ 4 callAddTimeToBucket  bucketTimes 9 fetch-dwords
      -> 0. $12345678. 0. 0. 0. 0. 0. 0. 0. }T
  $87654321. deltaTime 2!
  T{ 4 callAddTimeToBucket  bucketTimes 9 fetch-dwords
      -> 0. $99999999. 0. 0. 0. 0. 0. 0. 0. }T
  $00ffffff. deltaTime 2!
  T{ $10 callAddTimeToBucket  bucketTimes 9 fetch-dwords
      -> 0. $99999999. 0. 0. $00ffffff. 0. 0. 0. 0. }T
  $00020305. deltaTime 2!
  T{ $10 callAddTimeToBucket  bucketTimes 9 fetch-dwords
      -> 0. $99999999. 0. 0. $01020304. 0. 0. 0. 0. }T
  1. deltaTime 2!
  T{ $20 callAddTimeToBucket  bucketTimes 9 fetch-dwords
      -> 0. $99999999. 0. 0. $01020304. 0. 0. 0. 1. }T

  code callIncCountOfBucket ( x -- )
    sp X) lda  tax  incCountOfBucket  0 # ldx  Pop jmp end-code
  bucketCounts $24 erase
  T{ bucketCounts 9 fetch-dwords
      -> 0. 0. 0. 0. 0. 0. 0. 0. 0. }T
  T{ 4 callIncCountOfBucket  bucketCounts 9 fetch-dwords
      -> 0. 1. 0. 0. 0. 0. 0. 0. 0. }T
  T{ 4 callIncCountOfBucket  bucketCounts 9 fetch-dwords
      -> 0. 2. 0. 0. 0. 0. 0. 0. 0. }T
  T{ $20 callIncCountOfBucket  bucketCounts 9 fetch-dwords
      -> 0. 2. 0. 0. 0. 0. 0. 0. 1. }T
  T{ 0 callIncCountOfBucket  bucketCounts 9 fetch-dwords
      -> 1. 2. 0. 0. 0. 0. 0. 0. 1. }T
  $ff. bucketCounts 8 + 2!
  T{ 8 callIncCountOfBucket  bucketCounts 9 fetch-dwords
      -> 1. 2. $100. 0. 0. 0. 0. 0. 1. }T
  $ffff. bucketCounts $c + 2!
  T{ $0c callIncCountOfBucket  bucketCounts 9 fetch-dwords
      -> 1. 2. $100. $10000. 0. 0. 0. 0. 1. }T
  $ffffff. bucketCounts $10 + 2!
  T{ $10 callIncCountOfBucket  bucketCounts 9 fetch-dwords
      -> 1. 2. $100. $10000. $1000000. 0. 0. 0. 1. }T

  cr .( report) cr
  profiler-report

  cr .( test completed with ) #errors @ . .( errors) cr

\log logclose
