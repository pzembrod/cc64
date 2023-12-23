
~ create prevTime  4 allot
~ create deltaTime 4 allot

~ ' noop alias reset-32bit-timer  ( -- )
~ : read-32bit-timer  ( -- ud )  0. ;
~ ' noop alias reset-50ms-timer  ( -- )
~ ' 0 alias read-50ms-timer  ( -- u )

~ : ms.  ( u -- )
      drop ." -- ms" ;

current @ context @
Assembler also definitions

~ ' noop alias calcTime
~ ' noop alias setPrevTime

toss  context ! current !
