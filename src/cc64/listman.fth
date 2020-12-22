\ *** Block No. 18, Hexblock 12

\ listman: loadscreen          20sep94pz

\ terminology / interface:
\ hook-into     hook-out
\ heap>         >heap
\ ( init-heap )

\ *** Block No. 19, Hexblock 13

\ listman:                     12mar91pz

~ : hook-into ( element list -- )
     2dup  @ swap !  !  ;

~ : hook-out  ( list -- element/0 )
     dup @ dup
        IF dup @ rot !
        ELSE nip THEN ;


|| variable heap

~ : heap> ( -- element/0 )
     heap @ dup
        IF dup @ heap !
        ELSE *heapovfl* error THEN ;

~ : >heap ( element -- )
      heap hook-into ;


\ *** Block No. 20, Hexblock 14

\   listman: init              12mar91pz

|| : init-heap
     heap off
     ]heap heap[ ?DO
       I >heap
     /link +LOOP ;

  init: init-heap
