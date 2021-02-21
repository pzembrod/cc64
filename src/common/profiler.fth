
8 constant #buckets

variable prevTime
variable deltaTime
variable currentBucket

create bucketsLo    #buckets 1+ allot
create bucketsHi    #buckets 1+ allot
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
  IP 1+ lda  bucketsHi ,x cmp  0= ?[ IP lda  bucketsLo ,x cmp ]?
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

: (profiler-init
  currentBucket off  init-prevTime
  bucketTimes  #buckets 1+ 4 * erase
  bucketCounts #buckets 1+ 4 * erase
  bucketsLo    #buckets 2+ $f0 fill
  bucketsHi    #buckets 2+ $f0 fill
  ['] forth-83 >lo/hi bucketsHi c! bucketsLo c! ;

: profiler-bucket
  currentBucket @ 1+ dup >r currentBucket !
  here >lo/hi  bucketsHi r@ + c!  bucketsLo r> + c!
  0 c, ;

: profiler-bucket"
  currentBucket @ 1+ dup >r currentBucket !
  here >lo/hi  bucketsHi r@ + c!  bucketsLo r> + c!
  ," ;

: profiler-init  (profiler-init reset-32bit-timer install-prNext ;

: d[].  ( addr I -- ) 2* 2* + 2@  <# # # # # # # # #s #> type bl emit ;
: bucketaddr  ( I -- addr )
    bucketsLo over + c@ swap bucketsHi + c@ $100 * + ;

: profiler-report
    #buckets 1+ 0 DO
      I .  I bucketaddr u.  bucketCounts I d[].  bucketTimes I d[].
      I IF I bucketaddr count type THEN
      cr
    LOOP ;
