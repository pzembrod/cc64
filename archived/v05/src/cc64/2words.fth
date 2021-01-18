\ *** Block No. 129, Hexblock 81

\ 2! 2@ 2variable 2constant clv12may94pz

~ Code 2!  ( d adr --)
 tya  setup jsr  3 # ldy
 [[  SP )Y lda  N )Y sta  dey  0< ?]
 1 # ldy  Poptwo jmp  end-code

~ Code 2@  ( adr -- d)
 SP X) lda  N sta  SP )Y lda  N 1+ sta
 SP 2dec  3 # ldy
 [[  N )Y lda  SP )Y sta  dey  0< ?]
 xyNext jmp  end-code

~ : 2Variable  ( --)   Create 4 allot ;
             ( -- adr)

~ : 2Constant  ( d --)   Create , ,
  Does> ( -- d)   2@ ;
