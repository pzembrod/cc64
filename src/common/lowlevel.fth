
| Code c-charset
  (64 $cbfd jsr C)  (16 $f804 jsr C) (CX $0400 jsr C)
   xyNext jmp end-code

| : c-charset-present?  ( -- f )
  (64 $cbf9 C) (16 $f800 C) (CX $0403 C) 2@  $65021103. d= ;

\ Code bye
\ (64  $37 # lda  $1 sta  $a000 ) jmp  C)
\ (16  $fff6 jmp  C)
\ end-code
