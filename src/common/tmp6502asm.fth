\ *** Block No. 120, Hexblock 78

\ transient Assembler         c09may94pz

\ needs code  1 +load


\ *** Block No. 121, Hexblock 79

\ Forth-6502 Assembler         20sep94pz
\ Basis: Forth Dimensions VOL III No. 5)

 cr .( tmpheap transient forth assembler) cr

here   $800 tmp-hallot dp !

Onlyforth  Assembler also definitions
  ' noop alias |
  include 6502asm.fth  \ 1 7 +thru

\ : .blk  ( -) blk @ ?dup
\    IF  ."  Blk " u. ?cr  THEN ;
\ ' .blk Is .status

\ : rr ." error in scr " scr @ .
\      ."  at position " r# @ . cr ;

dp !

Onlyforth
