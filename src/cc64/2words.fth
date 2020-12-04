\ *** Block No. 129, Hexblock 81

\ 2! 2@

~ Code 2!  ( d adr --)
 tya  setup jsr  3 # ldy
 [[  SP )Y lda  N )Y sta  dey  0< ?]
 1 # ldy  Poptwo jmp  end-code

~ Code 2@  ( adr -- d)
 SP X) lda  N sta  SP )Y lda  N 1+ sta
 SP 2dec  3 # ldy
 [[  N )Y lda  SP )Y sta  dey  0< ?]
 xyNext jmp  end-code
