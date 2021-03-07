
8 constant #buckets

create prevTime  4 allot
create deltaTime 4 allot
variable currentBucket
variable currentBucketOpen

create <buckets[    #buckets 1+ allot
create >buckets[    #buckets 1+ allot
create <]buckets    #buckets 1+ allot
create >]buckets    #buckets 1+ allot
create bucketTimes  #buckets 1+ 4 * allot
create bucketCounts #buckets 1+ 4 * allot

Assembler also definitions

: calcTime
  sec
  prevTime 2+ lda  timerAlo sbc  deltaTime 2+ sta
  prevTime 3+ lda  timerAhi sbc  deltaTime 3+ sta
  prevTime    lda  timerBlo sbc  deltaTime    sta
  prevTime 1+ lda  timerBhi sbc  deltaTime 1+ sta
;

: setPrevTime
  timerAlo lda  prevTime 2+ sta
  timerAhi lda  prevTime 3+ sta
  timerBlo lda  prevTime    sta
  timerBhi lda  prevTime 1+ sta
;

: addTimeToBucket
  clc
  bucketTimes 2+ ,x lda  deltaTime 2+ adc  bucketTimes 2+ ,x sta
  bucketTimes 3+ ,x lda  deltaTime 3+ adc  bucketTimes 3+ ,x sta
  bucketTimes    ,x lda  deltaTime    adc  bucketTimes    ,x sta
  bucketTimes 1+ ,x lda  deltaTime 1+ adc  bucketTimes 1+ ,x sta
;

: incCountOfBucket
  bucketCounts 2+ ,x inc 0= ?[ bucketCounts 3+ ,x inc 0= ?[
     bucketCounts ,x inc 0= ?[ bucketCounts 1+ ,x inc  ]? ]? ]?
;

Label compareIp
  IP 1+ lda  >buckets[ ,x cmp  0= ?[ IP lda  <buckets[ ,x cmp ]?
  rts

: findBucket
  0 # ldx  compareIp jsr  CC ?[
    currentBucket ldx
  ][ inx  compareIp jsr  CC ?[
      dex
    ][
      5 # ldx
      compareIp jsr  0<> ?[  CC ?[ dex dex ][ inx inx ]?
      compareIp jsr  0<> ?[  CC ?[ dex     ][ inx     ]?
      compareIp jsr          CC ?[ dex     ]?             ]? ]?

      IP 1+ lda  >]buckets ,x cmp  0= ?[ IP lda  <]buckets ,x cmp ]?
        CS ?[ 0 # ldx ]?

      txa  .a asl  .a asl  tax
    ]?
    currentBucket stx
  ]?
;

Label prNext
  timerActrl lda  pha  $fe and  timerActrl sta
  calcTime
  findBucket
  incCountOfBucket
  addTimeToBucket
  setPrevTime
  0 # ldx  pla  timerActrl sta
  IP lda  2 # adc  Next $e + jmp

onlyforth

Code install-prNext \ installs prNext
 prNext 0 $100 m/mod
     # lda  Next $c + sta
     # lda  Next $b + sta
 $4C # lda  Next $a + sta  Next jmp
end-code

Code init-prevTime  setPrevTime  Next jmp end-code

: profiler-init-buckets
  currentBucket off  currentBucketOpen off  init-prevTime
  <buckets[    #buckets 2+ $ff fill
  >buckets[    #buckets 2+ $ff fill
  <]buckets    #buckets 2+ $ff fill
  >]buckets    #buckets 2+ $ff fill
  ['] forth-83 >lo/hi >buckets[ c! <buckets[ c! ;

: profiler-bucket
  create  last @ ,  0 , ;

: end-bucket  ( bucket -- )  here swap 2+ ! ;

: measure-bucket  ( bucket -- )
  currentBucket @ 1+ dup >r currentBucket ! \ check for #buckets
  dup @ >lo/hi  >buckets[ r@ + c!  <buckets[ r@ + c!
  2+  @ >lo/hi  >]buckets r@ + c!  <]buckets r> + c! ;

: profiler-metric:[
  create $0f ]
  does> profiler-init-buckets
  BEGIN dup @ ?dup WHILE execute measure-bucket  2+ REPEAT drop ;

: ]profiler-metric  $0f ?pairs  [compile] [  0 , ;  immediate restrict

: profiler-start
  bucketTimes  #buckets 1+ 4 * erase
  bucketCounts #buckets 1+ 4 * erase
  reset-32bit-timer  prevTime 4 erase
  install-prNext ;

: d[].  ( addr I -- ) 2* 2* + 2@ 12 d.r ;

: bucket[  ( I -- addr )
    <buckets[ over + c@ swap >buckets[ + c@ $100 * + ;

: ]bucket  ( I -- addr )
    <]buckets over + c@ swap >]buckets + c@ $100 * + ;

: profiler-report
    end-trace
    ." b# addr[  ]addr  nextcounts  clockticks  name" cr
    #buckets 1+ 0 DO
      I .  I bucket[ u.  I ]bucket u.
      bucketCounts I d[].  bucketTimes I d[].
      I IF I bucket[ 1+ IF ."   " I bucket[ count $1f and type THEN
      ELSE ."   (etc)" THEN
      cr
    LOOP ;
