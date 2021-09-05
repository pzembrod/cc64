
8 constant #buckets
4 constant #timestamps

create prevTime  4 allot
create deltaTime 4 allot
variable currentBucket
variable currentBucketOpen
variable metric-name

create <buckets[    #buckets 1+ allot
create >buckets[    #buckets 1+ allot
create <]buckets    #buckets 1+ allot
create >]buckets    #buckets 1+ allot
create bucketTimes  #buckets 1+ 4 * allot
create bucketCounts #buckets 1+ 4 * allot

create initialTimeStamp 4 allot
create timestamps[  #timestamps 4 * allot
here constant ]timestamps
variable timestamp>

create mainCount 4 allot
create countstamps[  #timestamps 4 * allot
here constant ]countstamps
variable countstamps>

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

: incMainCount
  mainCount 2+ inc 0= ?[ mainCount 3+ inc 0= ?[
     mainCount inc 0= ?[ mainCount 1+ inc  ]? ]? ]?
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
  timerActrl lda  pha  $fe # and  timerActrl sta
  calcTime
  findBucket
  incCountOfBucket
  addTimeToBucket
  setPrevTime
  incMainCount
  pla  timerActrl sta
  0 # ldx  clc  IP lda  Next $c + jmp

onlyforth

Code install-prNext
 prNext 0 $100 m/mod
     # lda  Next $b + sta
     # lda  Next $a + sta
 $4C # lda  Next $9 + sta
 Next jmp  end-code

Code end-profiler
 $18 # lda  Next $9 + sta
 $a5 # lda  Next $a + sta
  IP # lda  Next $b + sta
 Next jmp   end-code


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

: activate-bucket  ( bucket -- )
  currentBucket @ 1+ dup >r currentBucket ! \ check for #buckets
  dup @ >lo/hi  >buckets[ r@ + c!  <buckets[ r@ + c!
  2+  @ >lo/hi  >]buckets r@ + c!  <]buckets r> + c! ;

: profiler-metric:[
  create  last @ ,  here $0f ]
  does> profiler-init-buckets  dup @ metric-name !  2+
  BEGIN dup @ ?dup WHILE execute activate-bucket  2+ REPEAT drop ;

: ]profiler-metric  $0f ?pairs  [compile] [
  here swap -  #buckets 2* > abort" too many buckets in metric"
  0 , ;  immediate restrict

: profiler-timestamp
  read-32bit-timer  timestamp> @
  dup  4+ dup ]timestamps > abort" too many timestamps"
  timestamp> !  2!
  mainCount 2@  countstamps> @  dup 4+ countstamps> !  2! ;

: profiler-start
  bucketTimes  #buckets 1+ 4 * erase
  bucketCounts #buckets 1+ 4 * erase
  prevTime 4 erase   timestamps[ timestamp> !
  mainCount 4 erase  countstamps[ countstamps> !
  reset-32bit-timer  read-32bit-timer initialTimeStamp 2!
  install-prNext ;

: profiler-end  end-profiler  profiler-timestamp ;

: d[].  ( addr I -- ) 2* 2* + 2@ 12 d.r ;

: bucket[  ( I -- addr )
    <buckets[ over + c@ swap >buckets[ + c@ $100 * + ;

: ]bucket  ( I -- addr )
    <]buckets over + c@ swap >]buckets + c@ $100 * + ;

: d..  ( d -- )
  <# # #s #>  BEGIN swap dup c@ emit 1+ swap 1- dup WHILE
  dup 3 mod 0= IF ascii . emit THEN REPEAT 2drop bl emit ;

: profiler-report
    cr ." profiler report " metric-name @ count $1f and type cr
    ." timestamps" cr
    timestamps[ BEGIN dup timestamp> @ < WHILE
    dup 2@ dnegate initialTimestamp 2@ d+ d.. 4+ REPEAT drop cr
    ." countstamps" cr
    countstamps[ BEGIN dup countstamps> @ < WHILE
    dup 2@ d.. 4+ REPEAT drop cr
    cr ." buckets" cr
    ." b# addr[  ]addr  nextcounts  clockticks  name" cr
    #buckets 1+ 0 DO
      I .  I bucket[ u.  I ]bucket u.
      bucketCounts I d[].  bucketTimes I d[].
      I IF I bucket[ 1+ IF ."   " I bucket[ count $1f and type THEN
      ELSE ."   (etc)" THEN
      cr
    LOOP ;
